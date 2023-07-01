def middle_three_digits(num)
  # minus sign doesn't factor into digit count,
  # and calling #abs acts as a duck-type assertion
  num = num.abs

  # convert to string and find length
  length = (str = num.to_s).length

  # check validity
  raise ArgumentError, "Number must have at least three digits" if length < 3
  raise ArgumentError, "Number must have an odd number of digits" if length.even?

  return str[length/2 - 1, 3].to_i
end
