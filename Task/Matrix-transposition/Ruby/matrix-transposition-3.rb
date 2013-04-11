def transpose(m)
  m[0].zip(*m[1..-1])
end
p transpose([[1,2,3],[4,5,6]])
