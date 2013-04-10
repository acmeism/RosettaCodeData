(-2..12).map { |i| fib i rescue :error }
=> [:error, :error, 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]
