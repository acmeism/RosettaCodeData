def odd_magic_square(n)
  n.times.map{|i| n.times.map{|j| n*((i+j+1+n/2)%n) + ((i+2*j-5)%n) + 1} }
end

def single_even_magic_square(n)
  raise ArgumentError, "must be even, but not divisible by 4." unless (n-2) % 4 == 0
  raise ArgumentError, "2x2 magic square not possible." if n == 2

  order = (n-2)/4
  odd_square = odd_magic_square(n/2)
  to_add = (0..3).map{|f| f*n*n/4}
  quarts = to_add.map{|f| odd_square.dup.map{|row|row.map{|el| el+f}} }

  sq = []
  quarts[0].zip(quarts[2]){|d1,d2| sq << [d1,d2].flatten}
  quarts[3].zip(quarts[1]){|d1,d2| sq << [d1,d2].flatten}

  sq = sq.transpose
  order.times{|i| sq[i].rotate!(n/2)}
  swap(sq[0][order], sq[0][-order-1])
  swap(sq[order][order], sq[order][-order-1])
  (order-1).times{|i| sq[-(i+1)].rotate!(n/2)}
  randomize(sq)
end

def swap(a,b)
  a,b = b,a
end

def randomize(square)
  square.shuffle.transpose.shuffle
end

def to_string(square)
  n = square.size
  fmt = "%#{(n*n).to_s.size + 1}d" * n
  square.inject(""){|str,row| str << fmt % row << "\n"}
end

puts to_string(single_even_magic_square(6))
