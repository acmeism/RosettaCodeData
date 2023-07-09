x, y, z, one, three, seven = 5, -5, -2, 1, 3, 7


enums = (-three).step(3**3, three) +
        (-seven).step(seven, x) +
        555     .step(550-y, -1) +
        22      .step(-28, -three) +
        (1927..1939) +                # just toying, 1927.step(1939) is fine too
        x       .step(y, z) +
        (11**x) .step(11**x + one)
# enums is an enumerator, consisting of a bunch of chained enumerators,
# none of which has actually produced a value.

puts "Sum of absolute numbers:  #{enums.sum(&:abs)}"
prod = enums.inject(1){|prod, j| ((prod.abs < 2**27) && j!=0) ? prod*j : prod}
puts "Product (but not really): #{prod}"
