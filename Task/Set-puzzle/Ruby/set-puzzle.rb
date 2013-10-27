COLORS   = %i(red green purple) #use [:red, :green, :purple] in Ruby < 2.0
SYMBOLS  = %i(oval squiggle diamond)
NUMBERS  = %i(one two three)
SHADINGS = %i(solid open striped)
FEATURES = [COLORS, SYMBOLS, NUMBERS, SHADINGS]

@hand_size = 9
@num_sets_goal = 4

#create an enumerator which deals all combinations of @hand_size cards
@dealer = FEATURES[0].product(*FEATURES[1..-1]).shuffle.combination(@hand_size)

def get_all_sets(hand)
  hand.combination(3).select do |candidate|
    grouped_features = candidate.flatten.group_by{|f| f}
    grouped_features.values.none?{|v| v.size == 2}
  end
end

def get_puzzle_and_answer
  sets = []
  until sets.size == @num_sets_goal do
    hand = @dealer.next
    sets = get_all_sets(hand)
  end
  [hand, sets]
end

def print_cards(cards)
  cards.each{|card| puts card.join(", ")}
  puts
end

puzzle, sets =  get_puzzle_and_answer
puts "Dealt #{puzzle.size} cards:"
print_cards(puzzle)
puts "Containing #{sets.size} sets:"
sets.each{|set| print_cards(set)}
