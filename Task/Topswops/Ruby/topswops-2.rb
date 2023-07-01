def try_swaps(deck, f, d, n)
  @best[n] = d  if d > @best[n]
  (n-1).downto(0) do |i|
    break  if deck[i] == -1 || deck[i] == i
    return if d + @best[i] <= @best[n]
  end
  deck2 = deck.dup
  for i in 1...n
    k = 1 << i
    if deck2[i] == -1
      next  if f & k != 0
    elsif deck2[i] != i
      next
    end
    deck2[0] = i
    deck2[1..i] = deck[0...i].reverse
    try_swaps(deck2, f | k, d+1, n)
  end
end

def topswops(n)
  @best[n] = 0
  deck0 = [-1] * (n + 1)
  try_swaps(deck0, 1, 0, n)
  @best[n]
end

@best = [0] * 16
for i in 1..10
  puts "%2d : %d" % [i, topswops(i)]
end
