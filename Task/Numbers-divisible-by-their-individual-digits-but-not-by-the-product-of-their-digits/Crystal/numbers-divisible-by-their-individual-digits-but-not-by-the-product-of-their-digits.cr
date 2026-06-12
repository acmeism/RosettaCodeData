p (0..1000).select {|n|
  digits = n.digits
  digits.all? {|d| d != 0 && n % d == 0 } && n % digits.product != 0
}
