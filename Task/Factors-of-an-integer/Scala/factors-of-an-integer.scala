Brute force approach:

  def factors(num: Int) = {
    (1 to num).filter { divisor =>
      num % divisor == 0
    }

Since factors can't be higher than sqrt(num), the code above can be edited as follows
  def factors(num: Int) = {
    (1 to sqrt(num)).filter { divisor =>
      num % divisor == 0
    }
