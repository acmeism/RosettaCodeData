binomial_coefficient = (n, k) ->
  result = 1
  for i in [0...k]
    result *= (n - i) / (i + 1)
  result

n = 5
for k in [0..n]
  console.log "binomial_coefficient(#{n}, #{k}) = #{binomial_coefficient(n,k)}"
