local gfx <const> = playdate.graphics

class("Metronome").extends(Object)

function Metronome:init()
  
  self.elapsed = nil
  self.count = nil
  self.step = 1
  
  self.minBpm = 40
  self.maxBpm = 240
  
  self:setBpm(120)
  
  self.tick = playdate.sound.sampleplayer.new("sounds/tick.wav")
end

function Metronome:start()
  self.elapsed = 0
  self.count = 0
  self.tick:play()
  playdate.setAutoLockDisabled(true)
end

function Metronome:stop()
  self.elapsed = nil
  self.count = nil
  playdate.setAutoLockDisabled(false)
end

function Metronome:update(dt)
  if self.elapsed == nil then
    -- print("skip")
    return
  end
  
  self.elapsed += dt
  
  if self.elapsed > self.beatDuration then
    self.count += 1
    self.tick:play()
    
    -- print("tick", self.count)
    
    self.elapsed = self.elapsed % self.beatDuration
  end
end

function Metronome:isRunning() 
  return self.elapsed ~= nil
end

function Metronome:setBpm(value)
  local clamped = math.max(self.minBpm, math.min(self.maxBpm, value))
  local integer = math.floor(clamped)
  self.bpm = clamped
  self.beatDuration = (1 / integer) * 60 * 1000
  
  print("BPM", value)
end

function Metronome:getBpmRatio()
  return (self.bpm - self.minBpm) / (self.maxBpm - self.minBpm)
end
