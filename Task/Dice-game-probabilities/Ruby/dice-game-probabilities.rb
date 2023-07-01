def roll_dice(n_dice, n_faces)
  return [[0,1]] if n_dice.zero?
  one  = [1] * n_faces
  zero = [0] * (n_faces-1)
  (1...n_dice).inject(one){|ary,_|
    (zero + ary + zero).each_cons(n_faces).map{|a| a.inject(:+)}
  }.map.with_index(n_dice){|n,sum| [sum,n]}  # sum: total of the faces
end

def game(dice1, faces1, dice2, faces2)
  p1 = roll_dice(dice1, faces1)
  p2 = roll_dice(dice2, faces2)
  p1.product(p2).each_with_object([0,0,0]) do |((sum1, n1), (sum2, n2)), win|
    win[sum1 <=> sum2] += n1 * n2        # [0]:draw, [1]:win, [-1]:lose
  end
end

[[9, 4, 6, 6], [5, 10, 6, 7]].each do |d1, f1, d2, f2|
  puts "player 1 has #{d1} dice with #{f1} faces each"
  puts "player 2 has #{d2} dice with #{f2} faces each"
  win = game(d1, f1, d2, f2)
  sum = win.inject(:+)
  puts "Probability for player 1 to win: #{win[1]} / #{sum}",
       "                              -> #{win[1].fdiv(sum)}", ""
end
