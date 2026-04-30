require "levenshtein"

words = File.read_lines("unixdict.txt").to_set

print "Enter player names separated by spaces: "
players = gets.not_nil!.split

current = words.select { |w| 3 <= w.size <= 4 }.sample
used = Set.new [current]

puts "Starting word is '#{current}'!"

players.cycle.skip(players.size-1).each_cons_pair do |previous, player|
  print "#{player}, give me a wordiff from '#{current}': "
  guess = gets.not_nil!
  if guess.in?(words) && !guess.in?(used) && (dist = Levenshtein.distance(current, guess)) == 1
    puts "Good!"
    used << guess
    current = guess
  else
    possible = words.select {|w|
      !w.in?(used) && (w.size - guess.size).abs <= 1 && Levenshtein.distance(current, w) == 1
    }
    if !guess.in? words
      puts "That word isn't in the dictionary."
    elsif guess.in? used
      puts "That word was already used."
    else
      puts "That word isn't a wordiff from '#{guess}'."
    end
    puts "You LOSE, #{player}!"
    if possible.size > 0
      puts "You could have entered: #{possible.sort.join(", ")}"
    else
      puts "(But you didn't have any word left to enter. Brilliant move by #{previous}!)"
    end
    puts "#{previous} WINS!"
    break
  end
end
