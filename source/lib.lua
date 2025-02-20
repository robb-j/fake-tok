-- Little useful helpers

function mapValue(value, inMin, inMax, outMin, outMax)
  return outMin + (value - inMin) / (inMax - inMin) * (outMax - outMin)
end
