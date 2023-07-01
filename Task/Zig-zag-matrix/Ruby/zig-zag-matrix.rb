def zigzag(n)
  (seq=*0...n).product(seq)
    .sort_by {|x,y| [x+y, (x+y).even? ? y : -y]}
    .each_with_index.sort.map(&:last).each_slice(n).to_a
end

def print_matrix(m)
  format = "%#{m.flatten.max.to_s.size}d " * m[0].size
  puts m.map {|row| format % row}
end

print_matrix zigzag(5)
