def filtered(s1, s2)
  return enum_for(__method__, s1, s2) unless block_given?
  v, f = s1.next, s2.next
  loop do
    v > f and f = s2.next and next
    v < f and yield v
    v = s1.next
  end
end

squares, cubes = powers(2), powers(3)
f = filtered(squares, cubes)
p f.take(30).last(10)
# p f.lazy.drop(20).first(10)   # Ruby 2.0+
