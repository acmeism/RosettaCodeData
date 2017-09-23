function [n, maxLen] = longestHailstone(N)
  maxLen = 0;
  for k = 1:N
    a = k;
    kLen = 1;
    while a > 1
      if a ~= floor(a / 2) * 2
        a = a * 3 + 1;
      else
        a = a / 2;
      end
      kLen = kLen + 1;
    end
    if kLen > maxLen
      maxLen = kLen;
      n = k;
    end
  end
