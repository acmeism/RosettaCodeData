      Program Identity
      Integer N
      Parameter (N = 666)
      Real A(N,N)
      Integer i,j

      ForAll(i = 1:N, j = 1:N) A(i,j) = (i/j)*(j/i)

      END
