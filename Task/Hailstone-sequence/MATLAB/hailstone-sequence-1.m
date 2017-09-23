function x = hailstone(n)
  x = n;
  while n > 1
       % faster than mod(n, 2)
    if n ~= floor(n / 2) * 2
      n = n * 3 + 1;
    else
      n = n / 2;
    end
    x(end + 1) = n; %#ok
  end
