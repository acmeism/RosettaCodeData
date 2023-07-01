function floyds_triangle(n)
  s = 1;
  for k = 1 : n
    disp(s : s + k - 1)
    s = s + k;
  end
