require "prime"

class Integer

  def popcount
    to_s(2).count("1")   #Ruby 2.4:  digits(2).count(1)
  end

  def pernicious?
    popcount.prime?
  end

end

p 1.step.lazy.select(&:pernicious?).take(25).to_a
p ( 888888877..888888888).select(&:pernicious?)
