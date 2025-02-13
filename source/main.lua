import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/easing"

import "tapper"
import "metronome"
import "classic"
import "modern"

local gfx <const> = playdate.graphics

local metronome = Metronome()

local faces = { Modern() }
local face = faces[1]
local hold = nil
local lastTick = playdate.getCurrentTimeMilliseconds()
local tapper = Tapper(5)

function setup()
  -- TODO: load metronome from state
  face:setup(metronome)
  playdate.setCrankSoundsDisabled(true)
end

function playdate.update()
  local ms = playdate.getCurrentTimeMilliseconds()
  local dt = ms - lastTick
  
  metronome:update(dt)
  
  if face ~= nil then
    face:update(dt)
  end
  
  lastTick = ms
end

function playdate.cranked(change, acceleratedChange)
  if playdate.buttonIsPressed(playdate.kButtonB) or not metronome:isRunning() then
    -- ~~ 4 turns for 40 to 200
    local ratio = 0.5
    local value = (change / (math.pi * 2))  * ratio
    -- print(value)
    metronome:setBpm(metronome.bpm + value)
    tapper:reset()
  end
end

function playdate.BButtonDown()
  local bpm = tapper:add(playdate.getCurrentTimeMilliseconds())
  if bpm ~= nil then
    metronome:setBpm(bpm)
  end
end
  
setup()
