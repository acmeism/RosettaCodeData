def zigzag(n)
  indices = []
  n.times {|x| n.times {|y| indices << [x,y] }}
  zigzag = Array.new(n) {Array.new(n)}  # n x n array of nils
  indices.sort_by {|x,y| [x+y, (x+y).even? ? y : -y]} \
         .each_with_index {|(x,y),i| zigzag[x][y] = i}
  zigzag
end

def print_matrix(m)
  width = m.flatten.max.to_s.size
  m.each {|row| row.each {|val| print "%#{width}d " % val}; puts}
end

print_matrix zigzag(5)
