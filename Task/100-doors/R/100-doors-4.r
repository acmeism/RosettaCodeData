H=100
f=rep(F,H)
which(Reduce(function(d,n) xor(replace(f,seq(n,H,n),T),d), 1:H, f))
