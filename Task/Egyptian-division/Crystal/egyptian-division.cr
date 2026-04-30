def egyptian_div (dividend, divisor)
  powers_of_2 = [1]
  doublings = [divisor]
  while doublings.last * 2 <= dividend
    powers_of_2 << 2**powers_of_2.size
    doublings << doublings.last * 2
  end
  answer = accumulator = 0
  powers_of_2.zip(doublings).reverse_each do |power_of_2, doubling|
    if doubling + accumulator <= dividend
      accumulator += doubling
      answer += power_of_2
    end
  end
  {answer, dividend-accumulator}
end

p! egyptian_div(580, 34)
