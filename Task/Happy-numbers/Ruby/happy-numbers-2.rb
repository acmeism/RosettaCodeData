def print_happy
  happy_numbers = []

  1.step do |i|
    break if happy_numbers.length >= 8
    happy_numbers << i if happy?(i)
  end

  p happy_numbers
end

print_happy
