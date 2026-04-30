prod = 1
sum = 0
x = +5
y = -5
z = -2
one = 1
three = 3
seven = 7

Iterator(Int32).chain([(-three).step(to:   3**3, by: three),
                       (-seven).step(to: +seven, by: x),
                            555.step(to:    550 - y),
                             22.step(to:    -28, by: -three),
                           1927.step(to:   1939),
                              x.step(to:      y, by: z),
                        (11**x).step(to:  11**x + one)]).each do |j|
  sum += j.abs
  if prod.abs < 2**27 && j != 0
    prod *= j
  end
end

p! sum, prod
