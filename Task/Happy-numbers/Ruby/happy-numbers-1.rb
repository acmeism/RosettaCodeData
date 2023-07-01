require 'set' # Set: Fast array lookup / Simple existence hash

@seen_numbers = Set.new
@happy_numbers = Set.new

def happy?(n)
  return true if n == 1 # Base case
  return @happy_numbers.include?(n) if @seen_numbers.include?(n) # Use performance cache, and stop unhappy cycles

  @seen_numbers << n
  digit_squared_sum = n.digits.sum{|n| n*n}

  if happy?(digit_squared_sum)
    @happy_numbers << n
    true # Return true
  else
    false # Return false
  end
end
