ATTRIBUTES = [:number, :shading, :colour, :symbol]
Card    = Struct.new(*ATTRIBUTES){ def to_s = values.join(" ") }
combis  = %i[one two three].product(%i[solid striped open], %i[red green purple], %i[diamond oval squiggle])
PACK = combis.map{|combi| Card.new(*combi) }

def set?(trio) = ATTRIBUTES.none?{|attr| trio.map(&attr).uniq.size == 2 }

[4, 8, 12].each do |hand_size|
  puts "#{"_"*40}\n\nCards dealt: #{hand_size}"
  puts hand = PACK.sample(hand_size)
  sets = hand.combination(3).select{|h| set? h }
  puts "\n#{sets.size} sets found"
  sets.each{|set| puts set, ""}
end
