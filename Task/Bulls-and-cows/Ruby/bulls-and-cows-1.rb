def generate_word(len)
  [*"1".."9"].shuffle.first(len)        # [*"1".."9"].sample(len)  ver 1.9+
end

def get_guess(len)
  loop do
    print "Enter a guess: "
    guess = gets.strip
    err = case
          when guess.match(/[^1-9]/)             ; "digits only"
          when guess.length != len               ; "exactly #{len} digits"
          when guess.split("").uniq.length != len; "digits must be unique"
          else return guess.split("")
          end
    puts "the word must be #{len} unique digits between 1 and 9 (#{err}). Try again."
  end
end

def score(word, guess)
  bulls = cows = 0
  guess.each_with_index do |num, idx|
    if word[idx] == num
      bulls += 1
    elsif word.include? num
      cows += 1
    end
  end
  [bulls, cows]
end

word_length = 4
puts "I have chosen a number with #{word_length} unique digits from 1 to 9."
word = generate_word(word_length)
count = 0
loop do
  guess = get_guess(word_length)
  count += 1
  break if word == guess
  puts "that guess has %d bulls and %d cows" % score(word, guess)
end
puts "you guessed correctly in #{count} tries."
