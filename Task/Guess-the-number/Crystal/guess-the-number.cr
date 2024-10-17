n = rand(1..10)
puts "Guess the number: 1..10"
until gets.to_s.to_i == n; puts "Wrong! Guess again: " end
puts "Well guessed!"
