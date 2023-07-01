def double_even_magic_square(n)
  raise ArgumentError, "Need multiple of four" if n%4 > 0
  block_size, max = n/4, n*n
  pre_pat = [true, false, false, true,
             false, true, true, false]
  pre_pat += pre_pat.reverse
  pattern = pre_pat.flat_map{|b| [b] * block_size} * block_size
  flat_ar = pattern.each_with_index.map{|yes, num| yes ? num+1 : max-num}
  flat_ar.each_slice(n).to_a
end

def to_string(square)
  n = square.size
  fmt = "%#{(n*n).to_s.size + 1}d" * n
  square.inject(""){|str,row| str << fmt % row << "\n"}
end

puts to_string(double_even_magic_square(8))
