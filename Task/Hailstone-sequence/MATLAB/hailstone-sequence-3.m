  global VERBOSE;
  VERBOSE = 0;    % display of sequence elements turned off
  N = 100000;
  M = zeros(N,1);
  for k=1:N,
     M(k) = hailstone(k);   %display sequence
  end;
  [maxLength, n] = max(M)
