# This solution cheats and uses only one generator!

def powers(m)
  return enum_for(__method__, m) unless block_given?

  n = 0
  loop { yield n ** m; n += 1 }
end

def squares_without_cubes
  return enum_for(__method__) unless block_given?

  cubes = powers(3)
  c = cubes.next
  powers(2) do |s|
    c = cubes.next while c < s
    yield s unless c == s
  end
end

p squares_without_cubes.take(30).drop(20)
# p squares_without_cubes.lazy.drop(20).first(10)   # Ruby 2.0+
