testvalues = [{100000000000000.01,           100000000000000.011},
              {100.01,                       100.011},
              {10000000000000.001 / 10000.0, 1000000000.0000001000},
              {0.001,                        0.0010000001},
              {0.000000000000000000000101,   0.0},
              {(2**0.5) * (2**0.5),          2.0},
              {-(2**0.5) * (2**0.5),        -2.0},
              {Float64::NAN, Float64::NAN},
              {Float64::INFINITY, Float64::INFINITY},
             ]

struct Number
  def close_to? (num, tol = Float64::EPSILON)
    return true  if self == num
    return false if (self.to_f.nan? || num.to_f.nan?)          # NaN is not even close to itself
    return false if [self, num].count( Float64::INFINITY) == 1 # Infinity is only close to itself
    return false if [self, num].count(-Float64::INFINITY) == 1
    (self-num).abs <= tol * ({self.abs, num.abs}.max)
  end
end

testvalues.each do |a,b|
  puts "#{a} #{a.close_to?(b) ? '≈' : '≉'} #{b}"
end
