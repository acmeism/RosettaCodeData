deck = ([:black, :red] * 26 ).shuffle
black_pile, red_pile, discard = [], [], []

until deck.empty? do
  discard << deck.pop
  discard.last == :black ? black_pile << deck.pop : red_pile << deck.pop
end

x = rand( [black_pile.size, red_pile.size].min )

red_bunch   = x.times.map{ red_pile.delete_at( rand( red_pile.size )) }
black_bunch = x.times.map{ black_pile.delete_at( rand( black_pile.size )) }

black_pile += red_bunch
red_pile   += black_bunch

puts "The magician predicts there will be #{black_pile.count( :black )} red cards in the other pile.
Drumroll...
There were #{red_pile.count( :red )}!"
