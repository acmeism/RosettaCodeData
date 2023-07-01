function Q = Qsequence(N)
  %% zeros are used to pre-allocate memory, this is not strictly necessary but can significantly improve performance for large N
  Q = [1,1,zeros(1,N-2)];
  for n=3:N
    Q(n) = Q(n-Q(n-1))+Q(n-Q(n-2));
  end;
end;
