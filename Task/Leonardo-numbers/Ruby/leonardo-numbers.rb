def leonardo(l0=1, l1=1, add=1)
  return to_enum(__method__,l0,l1,add) unless block_given?
  loop do
    yield l0
    l0, l1 = l1, l0+l1+add
  end
end

p leonardo.take(25)
p leonardo(0,1,0).take(25)
