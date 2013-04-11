# -*- coding: euc-jp -*-

class Numeric
  def ≦(♯♭♪)
    self <= ♯♭♪
  end
end

∞ = Float::INFINITY
±5 = [-5, 5]
p [(±5.first.≦ ∞),
   (±5.last.≦ ∞),
   (∞.≦ ∞)]
