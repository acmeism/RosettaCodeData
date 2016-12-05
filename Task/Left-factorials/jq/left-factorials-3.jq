((range(0;11), (range(2; 12) * 10)) |  "\(.): \(long_left_factorial)"),

(10000 | long_left_factorial_lengths(1000) | .[] | "\(.[0]): length is \(.[1])")
