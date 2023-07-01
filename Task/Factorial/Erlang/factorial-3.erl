fac(N) -> fac(N-1,N).
fac(1,N) -> N;
fac(I,N) -> fac(I-1,N*I).
