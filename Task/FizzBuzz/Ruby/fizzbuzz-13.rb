1.upto(100) do |n|
  puts case [(n % 3).zero?, (n % 5).zero?]
       in true, false
         "Fizz"
       in false, true
         "Buzz"
       in true, true
         "FizzBuzz"
       else
         n
       end
end
