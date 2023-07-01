say lcm(18, 12)

-- calculate the greatest common denominator of a numerator/denominator pair
::routine gcd private
  use arg x, y

  loop while y \= 0
      -- check if they divide evenly
      temp = x // y
      x = y
      y = temp
  end
  return x

-- calculate the least common multiple of a numerator/denominator pair
::routine lcm private
  use arg x, y
  return x / gcd(x, y) * y
