1.upto(100) do |n|
  if (n % 15).zero?
    puts "FizzBuzz"
  elsif (n % 5).zero?
    puts "Buzz"
  elsif (n % 3).zero?
    puts "Fizz"
  else
    puts n
  end
end
