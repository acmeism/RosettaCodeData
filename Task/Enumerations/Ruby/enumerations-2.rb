module Card
  # constants
  SUITS = %i(Clubs Hearts Spades Diamonds)
  SUIT_VALUE = SUITS.each_with_index.to_h               # version 2.1+
# SUIT_VALUE = Hash[ SUITS.each_with_index.to_a ]       # before it
  #=> {:Clubs=>0, :Hearts=>1, :Spades=>2, :Diamonds=>3}

  PIPS = %i(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  PIP_VALUE = PIPS.each.with_index(2).to_h              # version 2.1+
# PIP_VALUE = Hash[ PIPS.each.with_index(2).to_a ]      # before it
  #=> {:"2"=>2, :"3"=>3, :"4"=>4, :"5"=>5, :"6"=>6, :"7"=>7, :"8"=>8, :"9"=>9, :"10"=>10, :Jack=>11, :Queen=>12, :King=>13, :Ace=>14}
end
