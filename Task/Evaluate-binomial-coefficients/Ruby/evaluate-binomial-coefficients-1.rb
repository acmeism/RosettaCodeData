class Integer
  # binomial coefficient: n C k
  def choose(k)
    # n!/(n-k)!
    pTop = (self-k+1 .. self).inject(1, &:*)
    # k!
    pBottom = (2 .. k).inject(1, &:*)
    pTop / pBottom
  end
end

p 5.choose(3)
p 60.choose(30)
