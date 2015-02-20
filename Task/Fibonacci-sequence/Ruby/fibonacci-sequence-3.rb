# Use the Hash#default_proc feature to
# lazily calculate the Fibonacci numbers.

fib = Hash.new do |f, n|
  f[n] = if n <= -2
           (-1)**(n + 1) * f[n.abs]
         elsif n <= 1
           n.abs
         else
           f[n - 1] + f[n - 2]
         end
end
# examples: fib[10] => 55, fib[-10] => (-55/1)
