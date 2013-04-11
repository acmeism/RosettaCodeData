nth_root = (A, n, precision=0.0000000000001) ->
  x = 1
  while true
    x_new = (1 / n) * ((n - 1) * x + A / Math.pow(x, n - 1))
    return x_new if Math.abs(x_new - x) < precision
    x = x_new

# tests
do ->
  tests = [
    [8, 3]
    [16, 4]
    [32, 5]
    [343, 3]
    [1024, 10]
    [1000000000, 3]
    [1000000000, 9]
    [100, 2]
    [100, 3]
    [100, 5]
    [100, 10]
  ]
  for test in tests
    [x, n] = test
    root = nth_root x, n
    console.log "#{x} root #{n} = #{root} (root^#{n} = #{Math.pow root, n})"
