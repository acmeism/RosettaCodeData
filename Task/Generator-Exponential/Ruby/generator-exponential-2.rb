# This solution uses three generators.

def powers(m)
  return enum_for(__method__, m) unless block_given?

  n = 0
  loop { yield n ** m; n += 1 }
end

def squares_without_cubes
  return enum_for(__method__) unless block_given?

  cubes = powers(3)
  c = cubes.next
  squares = powers(2)
  loop do
    s = squares.next
    c = cubes.next while c < s
    yield s unless c == s
  end
end

answer = squares_without_cubes
20.times { answer.next }
p 10.times.map { answer.next }
