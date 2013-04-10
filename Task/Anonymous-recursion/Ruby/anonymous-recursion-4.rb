# Ruby 1.9
(-2..12).map { |i| fib i rescue :error }
=> [:error, :error, 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]

# Ruby 1.8
(-2..12).map { |i| fib i rescue :error }
=> [:error, :error, 0, 1, 0, -3, -8, -15, -24, -35, -48, -63, -80, -99, -120]
