function f = chineseRemainder(r, m)
  s = prod(m) ./ m;
  [~, t] = gcd(s, m);
  f = s .* t * r';
