def sdaccum
  n, sum, sum2 = 0, 0.0, 0.0
  ->(num : Int32) do
    n += 1
    sum += num
    sum2 += num**2
    Math.sqrt( (sum2 * n - sum**2) / n**2 )
  end
end

sd = sdaccum
[2,4,4,4,5,5,7,9].each {|n| print sd.call(n), ", "}
