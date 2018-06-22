x, xi  = 2.0, 0.5
y, yi  = 4.0, 0.25
z, zi  = x + y, 1.0 / ( x + y )

multiplier = (n1, n2) -> (m) -> n1 * n2 * m

numlist  = [x ,  y,  z]
numlisti = [xi, yi, zi]

@show collect(multiplier(n, invn)(0.5) for (n, invn) in zip(numlist, numlisti))
