f = fn(n) when rem(n,15)==0 -> "FizzBuzz"
      (n) when rem(n,5)==0  -> "Fizz"
      (n) when rem(n,3)==0  -> "Buzz"
      (n)                   -> n
end

for n <- 1..100, do: IO.puts f.(n)
