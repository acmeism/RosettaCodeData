function D=pd(N)
K=1:ceil(N/2);
D=K(~(rem(N, K)));
