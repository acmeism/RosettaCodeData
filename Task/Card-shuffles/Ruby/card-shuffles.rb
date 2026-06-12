def riffle deck
  left, right = deck.partition{rand(10).odd?}
  new_deck    = []

  # the condition below is true when both left and right stacks are empty
  until ((left_card=left.pop).to_i + (right_card=right.shift).to_i).zero? do
    new_deck << left_card  if left_card
    new_deck << right_card if right_card
  end

  new_deck
end

def overhand deck
  deck, new_deck = deck.dup, []
  s = deck.size
  new_deck += deck.pop(rand(s * 0.2)) until deck.empty?
  new_deck
end

def bonus deck
  deck.sort { |a, b| Time.now.to_i % a <=> Time.now.to_i % b }
end

deck = [*1..20]

p riffle(deck)
p overhand(deck)
p bonus(deck)
