case X of
  {N,M} when N > M -> M;
  {N,M} when N < M -> N;
  _ -> equal
end.
