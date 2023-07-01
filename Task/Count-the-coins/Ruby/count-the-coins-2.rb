def make_change2(amount, coins)
  n, m = amount, coins.size
  table = Array.new(n+1){|i| Array.new(m, i.zero? ? 1 : nil)}
  for i in 1..n
    for j in 0...m
      table[i][j] = (i<coins[j] ? 0 : table[i-coins[j]][j]) +
                    (j<1        ? 0 : table[i][j-1])
    end
  end
  table[-1][-1]
end

p make_change2(   1_00, [1,5,10,25])
p make_change2(1000_00, [1,5,10,25,50,100])
