class Integer
  def fizzbuzz
    v = "#{"Fizz" if self % 3 == 0}#{"Buzz" if self % 5 == 0}"
    v.empty? ? self : v
  end
end

puts *(1..100).map(&:fizzbuzz)
