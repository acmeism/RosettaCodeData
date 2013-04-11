# This solution cheats and uses only one generator!

def powers(m)
  return enum_for(:powers, m) unless block_given?

  n = 0
  loop { yield n ** m; n += 1 }
end

def squares_without_cubes
  return enum_for(:squares_without_cubes) unless block_given?

  cubes = powers(3)
  c = cubes.next
  powers(2) do |s|
    (c = cubes.next) until c >= s
    yield s unless c == s
  end
end

p squares_without_cubes.take(30).drop(20)
