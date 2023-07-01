counter = 0

puts "Enter a maximum number:"
limit = gets

puts "Enter the first integer for factoring:"
first_int = gets
puts "Enter the name of the first integer:"
first_int_name = gets

puts "Enter the second integer for factoring:"
second_int = gets
puts "Enter the name of the second integer:"
second_int_name = gets

puts "Enter the third integer for factoring:"
third_int = gets
puts "Enter the name of the third integer:"
third_int_name = gets

if (limit &&
   first_int &&
   second_int &&
   third_int &&
   first_int_name &&
   second_int_name &&
   third_int_name)
  limit = limit.chomp.to_i
  first_int = first_int.chomp.to_i
  second_int = second_int.chomp.to_i
  third_int = third_int.chomp.to_i
  while limit > counter
    counter += 1
    if (counter % first_int) == 0 && (counter % second_int) == 0 && (counter % third_int) == 0
      puts first_int_name + second_int_name + third_int_name
    elsif (counter % first_int) == 0 && (counter % second_int) == 0
      puts first_int_name + second_int_name
    elsif (counter % first_int) == 0
      puts first_int_name
    elsif (counter % second_int) == 0
      puts second_int_name
    elsif (counter % third_int) == 0
      puts third_int_name
    else
      puts counter
    end
  end
else
  exit
end
