  x = [2,4,4,4,5,5,7,9];
  n = length (x);

  m  = mean (x);
  x2 = mean (x .* x);
  dev= sqrt (x2 - m * m)
  dev = 2
