import "lib"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class("Modern").extends(Object)

function Modern:init()
  self.charge = nil
  self.echo = nil
end

function Modern:setup(metronome)
  self.metronome = metronome
  self.charge = nil
  
  playdate.inputHandlers.push({
    AButtonDown = function()
      if self.metronome:isRunning() and self.echo == nil then
        local factor = self:getFactor()
        
        local startValue = factor
        local endValue = (startValue < 0.5 and 0.5 or 1.0)
        
        -- 
        -- turn back swings moving outwards, ie always start back to the center
        -- 
        if factor >= 0 and factor < 0.25 then
          startValue = 0.5 - factor
        end
        if factor >= 0.5 and factor < 0.75 then
          startValue = 1 - (factor - 0.5)
        end
          
        local numSwings = 2
        local duration = (endValue - startValue) * self.metronome.beatDuration + self.metronome.beatDuration * numSwings
        
        local timer = playdate.timer.new(duration, startValue, endValue + (numSwings/2))
        
        timer.timerEndedCallback = function (timer)
          self.echo = nil
        end
        
        self.metronome:stop()
        self.echo = timer
        
      elseif self.echo ~= nil then
        self.echo:remove()
        self.echo = nil
      else
        self.charge = 0
        self.echo = nil
      end
    end,
    AButtonUp = function() 
      -- ...
    end
  })
end

function Modern:teardown()
  playdate.inputHandlers.pop()
  self.metronome = nil
end

function Modern:update(dt)
  local width = playdate.display.getWidth()
  local height = playdate.display.getHeight()
  local center = width * 0.5
  
  gfx.clear()
  
  if self.charge ~= nil then
    if playdate.buttonIsPressed(playdate.kButtonA) then
      self.charge = math.min(self.charge + dt, self.metronome.beatDuration)
    else
      self.charge = self.charge - dt
      if self.charge <= 0 then
        self.charge = nil
        self.metronome:start()
      end
    end
  end
  
  if self.charge ~= nil then
    local ratio = 0.5 + self.charge / self.metronome.beatDuration / 4 -- 2 ????
    self:drawRatio(ratio, center, width, height)
    
  elseif self.echo ~= nil then
    local reducedWidth = width - mapValue(self.echo.value, self.echo.startValue, self.echo.endValue, 0, width)
    
    self:drawRatio(self.echo.value, center, reducedWidth, height)
  elseif self.metronome:isRunning() then    
    -- 0 to 1
    self:drawRatio(self:getFactor(), center, width, height)
  end
  
  self:drawBpm(height)
  
  -- DEBUG
  -- if self.metronome:isRunning() then
  --   gfx.drawText(self:getFactor(), width * 0.5, 5)
  -- end
end

function Modern:getFactor()
  local factor = self.metronome.elapsed / self.metronome.beatDuration / 2
  if self.metronome.count % 2 == 1 then
    factor = factor + 0.5
  end
  return factor
end

function Modern:drawBpm(height)
  local font = gfx.getSystemFont(gfx.font.kVariantBold)
  gfx.setFont(font)
  
  local factor = (self.metronome.bpm - self.metronome.minBpm) / (self.metronome.maxBpm - self.metronome.minBpm)
  -- local factor = mapValue(self.metronome.bpm, self.metronome.minBpm, self.metronome.maxBpm, 0, 1)
  
  local text = "" .. math.floor(self.metronome.bpm + 0.5)
  local textWidth, textHeight = gfx.getTextSize(text)
  textHeight -= 5
  textWidth = 40
  
  local x = 0
  local y = (1-factor) * (height - textHeight)
  
  local bpmUnlocked = playdate.buttonIsPressed(playdate.kButtonB) or not self.metronome:isRunning()
  local extraDisabled = self.echo or self.charge
  
  if bpmUnlocked and not extraDisabled then
    gfx.setColor(gfx.kColorXOR)
    gfx.fillRect(x - 5, y - 5, textWidth + 10, textHeight + 10)
  else
    
  end
  gfx.setImageDrawMode(gfx.kDrawModeNXOR)
  gfx.drawText(text, x, y, textWidth, textHeight, gfx.kAlignCenter)
    
end

function Modern:drawRatio(ratio, center, width, height)
  local value = math.sin(ratio * 2 * math.pi) * width * 0.5
  
  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(center, 0, value, height)
end
