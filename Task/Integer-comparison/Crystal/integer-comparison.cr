print("Enter first number: ")
a = gets.not_nil!.to_i

print("Enter second number: ")
b = gets.not_nil!.to_i

puts "#{a} is " +
     if a > b; "greater than"
     elsif a < b; "less than"
     elsif a == b; "equal to"
     else "?"
     end + " #{b}."
