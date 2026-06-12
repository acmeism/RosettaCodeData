"Numbers < 1000 divisible by their digits, but not by the product thereof:",
 (range(1; 1000)
  | select(is_divisible_by_digits_but_not_product))
