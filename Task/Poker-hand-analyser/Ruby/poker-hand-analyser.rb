class Card
  include Comparable
  attr_accessor :ordinal
  attr_reader :suit, :face

  SUITS = %i(♥ ♦ ♣ ♠)
  FACES = %i(2 3 4 5 6 7 8 9 10 j q k a)

  def initialize(str)
    @face, @suit = parse(str)
    @ordinal = FACES.index(@face)
  end

  def <=> (other) #used for sorting
    self.ordinal <=> other.ordinal
  end

  def to_s
    "#@face#@suit"
  end

  private
  def parse(str)
    face, suit = str.chop.to_sym, str[-1].to_sym
    raise ArgumentError, "invalid card: #{str}" unless FACES.include?(face) && SUITS.include?(suit)
    [face, suit]
  end
end

class Hand
  include Comparable
  attr_reader :cards, :rank

  RANKS       = %i(high-card one-pair two-pair three-of-a-kind straight flush
                   full-house four-of-a-kind straight-flush five-of-a-kind)
  WHEEL_FACES = %i(2 3 4 5 a)

  def initialize(str_of_cards)
    @cards = str_of_cards.downcase.tr(',',' ').split.map{|str| Card.new(str)}
    grouped = @cards.group_by(&:face).values
    @face_pattern = grouped.map(&:size).sort
    @rank = categorize
    @rank_num = RANKS.index(@rank)
    @tiebreaker = grouped.map{|ar| [ar.size, ar.first.ordinal]}.sort.reverse
  end

  def <=> (other)    # used for sorting and comparing
    self.compare_value <=> other.compare_value
  end

  def to_s
    @cards.map(&:to_s).join(" ")
  end

  protected          # accessible for Hands
  def compare_value
    [@rank_num, @tiebreaker]
  end

  private
  def one_suit?
    @cards.map(&:suit).uniq.size == 1
  end

  def consecutive?
    sort.each_cons(2).all? {|c1,c2| c2.ordinal - c1.ordinal == 1 }
  end

  def sort
    if @cards.sort.map(&:face) == WHEEL_FACES
      @cards.detect {|c| c.face == :a}.ordinal = -1
    end
    @cards.sort
  end

  def categorize
    if consecutive?
      one_suit? ? :'straight-flush' : :straight
    elsif one_suit?
      :flush
    else
      case @face_pattern
        when [1,1,1,1,1] then :'high-card'
        when [1,1,1,2]   then :'one-pair'
        when [1,2,2]     then :'two-pair'
        when [1,1,3]     then :'three-of-a-kind'
        when [2,3]       then :'full-house'
        when [1,4]       then :'four-of-a-kind'
        when [5]         then :'five-of-a-kind'
      end
    end
  end
end

# Demo
test_hands = <<EOS
2♥ 2♦ 2♣ k♣ q♦
2♥ 5♥ 7♦ 8♣ 9♠
a♥ 2♦ 3♣ 4♣ 5♦
2♥ 3♥ 2♦ 3♣ 3♦
2♥ 7♥ 2♦ 3♣ 3♦
2♥ 6♥ 2♦ 3♣ 3♦
10♥ j♥ q♥ k♥ a♥
4♥ 4♠ k♠ 2♦ 10♠
4♥ 4♠ k♠ 3♦ 10♠
q♣ 10♣ 7♣ 6♣ 4♣
q♣ 10♣ 7♣ 6♣ 3♣
9♥ 10♥ q♥ k♥ j♣
2♥ 3♥ 4♥ 5♥ a♥
2♥ 2♥ 2♦ 3♣ 3♦
EOS

hands = test_hands.each_line.map{|line| Hand.new(line) }
puts "High to low"
hands.sort.reverse.each{|hand| puts "#{hand}\t #{hand.rank}" }
puts

str = <<EOS
joker  2♦  2♠  k♠  q♦
joker  5♥  7♦  8♠  9♦
joker  2♦  3♠  4♠  5♠
joker  3♥  2♦  3♠  3♦
joker  7♥  2♦  3♠  3♦
joker  7♥  7♦  7♠  7♣
joker  j♥  q♥  k♥  A♥
joker  4♣  k♣  5♦ 10♠
joker  k♣  7♣  6♣  4♣
joker  2♦  joker  4♠  5♠
joker  Q♦  joker  A♠ 10♠
joker  Q♦  joker  A♦ 10♦
joker  2♦  2♠  joker  q♦
EOS

# Neither the Card nor the Hand class supports jokers
# but since hands are comparable, they are also sortable.
# Try every card from a deck for a joker and pick the largest hand:

DECK = Card::FACES.product(Card::SUITS).map(&:join)
str.each_line do |line|
  cards_in_arrays = line.split.map{|c| c == "joker" ? DECK.dup : [c]} #joker is array of all cards
  all_tries  = cards_in_arrays.shift.product(*cards_in_arrays).map{|ar| Hand.new(ar.join" ")} #calculate the Whatshisname product
  best = all_tries.max
  puts "#{line.strip}: #{best.rank}"
end
