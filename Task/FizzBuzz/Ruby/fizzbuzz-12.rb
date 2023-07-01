fizzbuzz = ->(i) do
  (i%15).zero? and next "FizzBuzz"
  (i%3).zero?  and next "Fizz"
  (i%5).zero?  and next "Buzz"
  i
end

puts (1..100).map(&fizzbuzz).join("\n")
