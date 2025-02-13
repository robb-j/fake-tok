local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class("Classic").extends(Object)

function Classic:init()
  self.metronome = nil
  self.hold = nil
  self.origin = nil
  
  self.angle = math.pi
  self.accel = 0
  self.vel = 0
end

function Classic:setup(metronome)
  self.metronome = metronome
  self.origin = geom.point.new(
    playdate.display.getWidth() * 0.5,
    playdate.display.getHeight() * 0.5 -- 2
  )
  
  playdate.inputHandlers.push({
    AButtonDown = function() 
      self.hold = 0
      print("a", self)
    end,
    
    AButtonUp = function() 
      print("held", self.hold)
      self.hold = nil
      
      -- TODO: wait for it to swing to the top?
      
      if self.metronome:isRunning() then
        self.metronome:stop()
      else
        self.metronome:start()
      end
    end
  })
end

function Classic:teardown()
  self.metronome = nil
  playdate.inputHandlers.pop()
end

function Classic:update(dt)
  
  if self.hold ~= nil and playdate.buttonIsPressed( playdate.kButtonA ) then
    self.hold += dt
  end
  
  gfx.setLineWidth(10)
  gfx.setColor(gfx.kColorBlack)
  
  if self.metronome:isRunning() then
    local length = self.origin.y - 30
    -- local theta = math.sin(self.metronome.elapsed)
    
    local gravity = 0.1
    
    local msPerBeat = 1/self.metronome.bpm * 60 * 1000
    -- local factor = 
    local theta = ((self.metronome.elapsed % msPerBeat) / msPerBeat) * math.pi * 2
    print(theta)
    
    -- print(self.metronome.elapsed / self.metronome.bpm / 60 / 1000)
    
    -- self.accel = -1 * gravity * math.sin(self.angle) / length
    -- self.vel += self.accel
    -- self.angle += self.vel
    
    gfx.clear()
    
    gfx.drawLine(
      self.origin.x,
      self.origin.y,
      self.origin.x + math.sin(theta) * length,
      self.origin.y + math.cos(theta) * length
    )
    
    -- print(self.angle, self.accel, self.vel, self.angle, length)
    
    -- print(self.hold, self.metronome:getCount())
  end
end
