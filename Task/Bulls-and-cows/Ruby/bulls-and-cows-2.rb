size = 4
secret = [*'1' .. '9'].sample(size)
guess = nil

i=0
loop do
  i+=1
  loop do
    print "Guess #{i}: "
    guess = gets.chomp.chars
    exit if guess.empty?

    break if guess.size == size and
             guess.all? { |x| ('1'..'9').include? x } and
             guess.uniq.size == size

    puts "Problem, try again. You need to enter #{size} unique digits from 1 to 9"
  end

  if guess == secret
    puts "Congratulations you guessed correctly in #{i} attempts"
    break
  end

  bulls = cows = 0
  size.times do |j|
    if guess[j] == secret[j]
      bulls += 1
    elsif secret.include? guess[j]
      cows += 1
    end
  end

  puts "Bulls: #{bulls}; Cows: #{cows}"
end
