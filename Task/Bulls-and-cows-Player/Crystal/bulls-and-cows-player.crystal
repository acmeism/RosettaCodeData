size = 4
scores = [] of Tuple(Int32, Int32)
guesses = [] of Array(Char)
puts "Playing Bulls & Cows with #{size} unique digits."
possible_guesses = ('1'..'9').to_a.permutations(size).shuffle

loop do
  guesses << (current_guess = possible_guesses.pop)
  print "Guess #{guesses.size} (#{possible_guesses.size}) is #{current_guess.join}. Answer (bulls,cows)? "
  bulls, cows = gets.not_nil!.split(',').map(&.to_i)
  scores << (score = {bulls, cows})

  # handle win
  break (puts "Yeah!") if score == {size, 0}

  # filter possible guesses
  possible_guesses.select! do |guess|
    bulls = guess.zip(current_guess).count { |g, cg| g == cg }
    cows = size - (guess - current_guess).size - bulls
    {bulls, cows} == score
  end

  # handle 'no possible guesses left'
  if possible_guesses.empty?
    puts "Error in scoring?"
    guesses.zip(scores).each { |g, (b, c)| puts "#{g.join} => bulls #{b} cows #{c}" }
    break
  end
end
