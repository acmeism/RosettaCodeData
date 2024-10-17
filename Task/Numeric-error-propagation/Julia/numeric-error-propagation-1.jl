using Measurements

x1 = measurement(100, 1.1)
x2 = measurement(200, 2.2)
y1 = measurement(50, 1.2)
y2 = measurement(100, 2.3)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2)

@show d
@show d.val, d.err
