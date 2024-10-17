def zigzag(n)
  (seq=(0...n).to_a).product(seq)
    .sort_by {|x,y| [x+y, (x+y).even? ? y : -y]}
    .map_with_index{|v, i| {v, i}}.sort.map(&.last).each_slice(n).to_a
end

def print_matrix(m)
  format = "%#{m.flatten.max.to_s.size}d " * m[0].size
  m.each {|row| puts format % row}
end

print_matrix zigzag(5)
