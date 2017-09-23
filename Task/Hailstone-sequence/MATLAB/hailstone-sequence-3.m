N = 1e5;
maxLen = 0;
for k = 1:N
  kLen = numel(hailstone(k));
  if kLen > maxLen
    maxLen = kLen;
    n = k;
  end
end
