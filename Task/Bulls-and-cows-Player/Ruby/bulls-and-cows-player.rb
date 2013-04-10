size = 4
scores = []
guesses = []
puts "Playing Bulls & Cows with #{size} unique digits."
possible_guesses = ('1'..'9').to_a.permutation(size).to_a.shuffle

while
  guesses << current_guess = possible_guesses.pop
  print "Guess #{guesses.size} is #{current_guess.join}. Answer (bulls,cows)? "
  scores << score = gets.split(',').map(&:to_i)

  # handle win
  break (puts "Yeah!") if score == [size,0]

  # filter possible guesses
  possible_guesses.select! do |pos_guess|
    bulls = pos_guess.zip(current_guess).count{|digit_pair| digit_pair[0] == digit_pair[1]}
    cows = pos_guess.count{|digit| current_guess.include?( digit )} - bulls
    [bulls, cows] == score
  end

  # handle 'no possible guesses left'
  if possible_guesses.empty? then
    puts "Error in scoring?"
    guesses.zip(scores).each{|g, (b, c)| puts "#{g.join} => bulls #{b} cows #{c}"}
    break
  end
end
