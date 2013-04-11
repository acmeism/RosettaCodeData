def sdaccum
  n, sum, sum2 = 0, 0.0, 0.0
  lambda do |num|
    n += 1
    sum += num
    sum2 += num**2
    Math.sqrt( (sum2 / n) - (sum / n)**2 )
  end
end

sd = sdaccum
[2,4,4,4,5,5,7,9].each {|n| print sd.call(n), ", "}
