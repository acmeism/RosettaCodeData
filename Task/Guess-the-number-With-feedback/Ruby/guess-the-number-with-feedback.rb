number = rand(1..10)

puts "Guess the number between 1 and 10"

guessed = false

until guessed do
  begin
    user_number = Integer(gets)
    if user_number == number
      guessed = true
      puts "You guessed it."
    elsif user_number > number
      puts "Too high."
    else
      puts "Too low."
    end
  rescue ArgumentError => e
    puts "Please enter an integer."
  end
end
