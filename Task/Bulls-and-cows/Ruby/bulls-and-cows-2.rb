$size = 4
$secret = [*'1' .. '9'].shuffle.first $size

i=0
loop do
  i+=1

  loop do
    print "Guess #{i}: "
    $guess = gets.chomp.chars.to_a
    exit if $guess.empty?

    break if $guess.size == $size and
      $guess.all? { |x| ('1'..'9').include? x } and
      $guess.uniq.size == $size

    puts "Problem, try again. You need to enter #{$size} unique digits from 1 to 9"
  end

  if $guess == $secret
    puts "Congratulations you guessed correctly in #{i} attempts"
    break
  end

  bulls = cows = 0

  $size.times do |j|
    bulls += 1 if $guess[j] == $secret[j]
    cows += 1 if $secret.include? $guess[j]
  end

  puts "Bulls: #{bulls}; Cows: #{cows}"
end
