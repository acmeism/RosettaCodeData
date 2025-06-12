def agm (a : Float64, g : Float64)
  while a - g >= Float64::EPSILON
    a, g = (a + g) / 2, Math.sqrt(a * g)
  end
  g
end

p agm(1, 1 / Math.sqrt(2))
