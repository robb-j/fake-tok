class("Tapper").extends(Object)

function Tapper:init(size)
  self.size = size
  self.values = table.create(size, 0)
  self.index = nil
  for i = 1, size do
    self.values[i] = nil
  end
end

function Tapper:add(ms)
  if self.index == nil then
    self.index = 1
  else
    self.index = (self.index) % self.size + 1
  end
  self.values[self.index] = ms
  return self:getBpm()
end

function Tapper:getBpm()
  if self.index == nil then
    return nil
  end
  
  local last = nil
  local count = 0
  local sum = 0
  
  for i = 0, self.size - 1 do
    -- (3 + 3 - 1) % 5 + 1
    local index = ((self.index + i) % self.size) + 1
    local value = self.values[index]
    
    -- print("index=", index, " value=", value)
    
    if value ~= nil then
      if last ~= nil then
        local diff = value - last
        if diff < 1000 then
          count += 1
          sum += diff
        end
      end
      
      last = value
    end
  end
  
  if count < 1 then
    return nil
  end
  
  return (1 / (sum / count)) * 60 * 1000
end

function Tapper:reset()
  if self.index ~= nil then
    self.index = nil
    for i = 1, self.size do
      self.values[i] = nil
    end
  end
end


-- 
-- current = 3
-- 
-- | index |   1 |   2 |   3 |   4 |   5 |
-- | value | 300 | 400 | 500 | 100 | 200 |
-- 
-- beat duration ~ 100
-- BPM 600 1 / 100 * 1000 * 60 = 600
-- 
