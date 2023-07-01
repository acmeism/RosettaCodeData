 function Q = HCsequence(N)
  Q = zeros(1,N);
  Q(1:2) = 1;
  for n = 3:N,
    Q(n) = Q(Q(n-1))+Q(n-Q(n-1));
  end;
end;
