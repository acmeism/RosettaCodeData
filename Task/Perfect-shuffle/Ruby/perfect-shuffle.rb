def perfect_shuffle(deck_size = 52)
  deck     = (1..deck_size).to_a
  original = deck.dup
  half     = deck_size / 2
  1.step do |i|
    deck = deck.first(half).zip(deck.last(half)).flatten
    return i if deck == original
  end
end

[8, 24, 52, 100, 1020, 1024, 10000].each {|i| puts "Perfect shuffles required for deck size #{i}: #{perfect_shuffle(i)}"}
