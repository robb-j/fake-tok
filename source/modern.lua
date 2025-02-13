local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class("Modern").extends(Object)

function Modern:init()
  self.charge = nil
end

function Modern:setup(metronome)
  self.metronome = metronome
  self.charge = nil
  
  playdate.inputHandlers.push({
    AButtonDown = function()
      if not self.metronome:isRunning() then
        self.charge = 0
      end
    end,
    AButtonUp = function() 
      if self.metronome:isRunning() then
        self.metronome:stop()
      end
      -- 
      -- if self.metronome:isRunning() then
      --   self.metronome:stop()
      -- else
      --   self.metronome:start()
      -- end
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
    local ratio = 0.5 + self.charge / self.metronome.beatDuration / 4
    self:drawRatio(ratio, width, height)
    
  elseif self.metronome:isRunning() then    
    -- 0 to 1
    local factor = self.metronome.elapsed / self.metronome.beatDuration / 2
    if self.metronome.count % 2 == 1 then
      factor = factor + 0.5
    end
    
    self:drawRatio(factor, width, height)
  end
  
  local font = gfx.getSystemFont(gfx.font.kVariantBold)
  gfx.setFont(font)
  
  local bpmFactor = (self.metronome.bpm - self.metronome.minBpm) / (self.metronome.maxBpm - self.metronome.minBpm)
  
  -- gfx.setColor(gfx.kColorXOR)
  gfx.drawText(
    math.floor(self.metronome.bpm + 0.5),
    10,
    10 + bpmFactor * (height - 35)
  )
end

function Modern:drawRatio(ratio, width, height)
  -- print(self.metronome.count, "", factor)
  -- print(factor)
  
  -- local value = playdate.easingFunctions.inOutSine(factor, -width/2, width, 1.0)
  
  -- local value = math.sin(factor * math.pi * 0.5) * width
  
  local value = math.sin(ratio * 2 * math.pi) * width * 0.51
  
  -- local value = factor * width
  
  -- local value = playdate.easingFunctions.outSine(factor, 0, width, 1.0)
  
  
  -- gfx.setColor(gfx.kColorWhite)
  -- gfx.fillRect(0, 0, width, height)
  
  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(width * 0.5, 0, value, height)
end
