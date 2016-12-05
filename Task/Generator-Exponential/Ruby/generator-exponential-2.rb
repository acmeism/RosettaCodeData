# This solution uses three generators.

def powers(m)
  return enum_for(__method__, m) unless block_given?
  0.step{|n| yield n**m}
end

def squares_without_cubes
  return enum_for(__method__) unless block_given?

  cubes = powers(3) #no block, so this is the first generator
  c = cubes.next
  squares = powers(2) # second generator
  loop do
    s = squares.next
    c = cubes.next while c < s
    yield s unless c == s
  end
end

answer = squares_without_cubes # third generator
20.times { answer.next }
p 10.times.map { answer.next }
