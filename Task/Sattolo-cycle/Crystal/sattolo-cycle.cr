module Indexable::Mutable
  def sattolo!
    (size-1).downto(1) do |i|
      j = Random.rand i
      swap i, j
    end
    self
  end
end

a = [1, 2, 3]
p a
p a.sattolo!
