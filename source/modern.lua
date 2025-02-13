local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class("Modern").extends(Object)

function Modern:init()
end

function Modern:setup(metronome)
  self.metronome = metronome
  
  playdate.inputHandlers.push({
    AButtonUp = function() 
      if self.metronome:isRunning() then
        self.metronome:stop()
      else
        self.metronome:start()
      end
    end
  })
end

function Modern:teardown()
  playdate.inputHandlers.pop()
  self.metronome = nil
end

function Modern:update(dt)
  if self.metronome:isRunning() then
    local twoPi = math.pi * 2
    local width = playdate.display.getWidth()
    local height = playdate.display.getHeight()
    
    local beatDuration = (1 / self.metronome.bpm) * 60 * 1000
    
    -- 0 to 1
    local factor = self.metronome.elapsed / self.metronome.beatDuration / 2
    if self.metronome.count % 2 == 1 then
      factor = factor + 0.5
    end
    
    -- print(self.metronome.count, "", factor)
    -- print(factor)
    
    -- local value = playdate.easingFunctions.inOutSine(factor, -width/2, width, 1.0)
    
    -- local value = math.sin(factor * math.pi * 0.5) * width
    
    local value = math.sin(factor * twoPi) * width * 0.51
    
    -- local value = factor * width
    
    -- local value = playdate.easingFunctions.outSine(factor, 0, width, 1.0)
    
    gfx.clear()
    -- gfx.setColor(gfx.kColorWhite)
    -- gfx.fillRect(0, 0, width, height)
    
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(width * 0.5, 0, value, height)
    
    
    -- gfx.setColor(gfx.kColorXOR)
    local font = gfx.getSystemFont(gfx.font.kVariantBold)
    gfx.setFont(font)
    gfx.drawText(math.floor(self.metronome.bpm + 0.5), 10, 10)
    -- gfx.fillRect(50, 50, 50, 50)
    
    
  end
end
