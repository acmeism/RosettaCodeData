def succ(n)
  n+1
end
def to2(m)
  m[2]
end

meth = method(:succ)
to2(meth) #=> 3
