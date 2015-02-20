y = ->(f) {->(g) {g.(g)}.(->(g) { f.(->(*args) {g.(g).(*args)})})}

fac = ->(f) { ->(n) { n < 2 ? 1 : n * f.(n-1) } }

p 10.times.map {|i| y.(fac).(i)}

fib = ->(f) { ->(n) { n < 2 ? n : f.(n-2) + f.(n-1) } }

p 10.times.map {|i| y.(fib).(i)}
