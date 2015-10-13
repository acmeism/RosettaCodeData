#   games = ARGV converted to Integer
#   No arguments? Pick any of first 32000 games.
begin
  games = ARGV.map {|s| Integer(s)}
rescue => err
  $stderr.puts err.inspect
  $stderr.puts "Usage: #{__FILE__} number..."
  abort
end
games.empty? and games = [rand(32000)]

# Create original deck of 52 cards, not yet shuffled.
orig_deck = %w{A 2 3 4 5 6 7 8 9 T J Q K}.product(%w{C D H S}).map(&:join)

games.each do |seed|
  deck = orig_deck.dup

  # Shuffle deck with random index from linear congruential
  # generator like Microsoft.
  state = seed
  52.downto(2) do |len|
    state = ((214013 * state) + 2531011) & 0x7fff_ffff
    index = (state >> 16) % len
    last = len - 1
    deck[index], deck[last] = deck[last], deck[index]
  end

  deck.reverse!  # Shuffle did reverse deck. Do reverse again.

  # Deal cards.
  puts "Game ##{seed}"
  deck.each_slice(8) {|row| puts " " + row.join(" ")}
  puts
end
