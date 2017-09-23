n = 2 ^ 4 - 1;
tr = + ~(-n : n);
for k = 1:n
  tr(k + 1, :) = bitget(90, 1 + filter2([4 2 1], tr(k, :)));
end
char(10 * tr + 32)
