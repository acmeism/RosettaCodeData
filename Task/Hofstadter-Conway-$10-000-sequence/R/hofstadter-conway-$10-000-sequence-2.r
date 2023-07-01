hofcon = c(1, 1, rep(NA, 2^20 - 2))
for (n in 3 : (2^20))
  {hofcon[n] =
       hofcon[hofcon[n - 1]] +
       hofcon[n - hofcon[n - 1]]}
