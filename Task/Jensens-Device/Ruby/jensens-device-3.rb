def sum lo, hi, &term
    (lo..hi).map(&term).reduce(:+)
end
p sum(1,100){|i|1.0/i}   # => 5.187377517639621
# or using Rational:
p sum(1,100){|i|Rational(1)/i}  # => 14466636279520351160221518043104131447711 / 2788815009188499086581352357412492142272
