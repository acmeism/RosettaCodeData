class Integer
  def square?
    isqrt = Integer.sqrt(self)
    isqrt*isqrt == self
  end
end

list = [3,4,34,25,9,12,36,56,36].chain(
       [2,8,81,169,34,55,76,49,7],
       [75,121,75,144,35,16,46,35])

p list.select(&:square?).sort
