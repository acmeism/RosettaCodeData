def generate_word(len)
  ([1, 2, 3, 4, 5, 6, 7, 8, 9].shuffle)[0,len].join("")
end

def get_guess(len)
  while true
    print "Enter a guess: "
    guess = gets.strip
    err = case
          when guess.match(/\D/)                 : "digits only"
          when guess.length != len               : "exactly #{len} digits"
          when guess.split("").uniq.length != len: "digits must be unique "
          else nil
          end
    break if err.nil?
    puts "the word must be #{len} unique digits between 1 and 9 (#{err}).  Try again."
  end
  guess
end

def score(word, guess)
  bulls = cows = 0
  guess.bytes.each_with_index do |byte, idx|
    if word[idx] == byte
      bulls += 1
    elsif word.include? byte
      cows += 1
    end
  end
  [bulls, cows]
end

srand
word_length = 4
puts "I have chosen a number with #{word_length} unique digits from 1 to 9."
word = generate_word(word_length)
count = 0
while true
  guess = get_guess(word_length)
  count += 1
  break if word == guess
  puts "that guess has %d bulls and %d cows" % score(word, guess)
end
puts "you guessed correctly in #{count} tries."
