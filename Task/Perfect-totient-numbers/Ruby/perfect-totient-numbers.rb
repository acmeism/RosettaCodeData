require "prime"

class Integer

  def φ
    prime_division.inject(1) {|res, (pr, exp)| res *= (pr-1) * pr**(exp-1) }
  end

  def perfect_totient?
    f, sum = self, 0
    until f == 1 do
      f = f.φ
      sum += f
    end
    self == sum
  end

end

puts (1..).lazy.select(&:perfect_totient?).first(20).join(", ")
