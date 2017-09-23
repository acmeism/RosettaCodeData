function [n, maxLen] = longestHailstone(N)
  lenList(N) = 0;
  lenList(1) = 1;
  maxLen = 0;
  for k = 2:N
    a = k;
    kLen = 0;
    while a >= k
      if a == floor(a / 2) * 2
        a = a / 2;
      else
        a = a * 3 + 1;
      end
      kLen = kLen + 1;
    end
    kLen = kLen + lenList(a);
    lenList(k) = kLen;
    if kLen > maxLen
      maxLen = kLen;
      n = k;
    end
  end
