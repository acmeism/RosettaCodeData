  m = cumsum(x) ./ [1:n];	% running mean
  x2= cumsum(x.^2) ./ [1:n];   % running squares

  dev = sqrt(x2 - m .* m)
  dev =
   0.00000   1.00000   0.94281   0.86603   0.97980   1.00000   1.39971   2.00000
