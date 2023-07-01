largestpd(n) = (for i in n÷2:-1:1 (n % i == 0) && return i; end; 1)

foreach(n -> print(rpad(largestpd(n), 3), n % 10 == 0 ? "\n" : ""), 1:100)
