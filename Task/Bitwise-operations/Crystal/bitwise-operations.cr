def operations (x, y)
  p! x, y,
     x & y, x | y, x ^ y,
     ~x,
     x << y, x >> y,
     x.rotate_left(y), x.rotate_right(y)
end

operations 10, 2
