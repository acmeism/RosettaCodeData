P =: 3 :0 NB. list of coefficients for yth Legendre polynomial
   if. y<:1 do. 1{.~->:y return. end.
   y%~ (<:(,~+:)y) -/@:* (0,P<:y),:(P y-2)
)

getpoints =: 3 :0 NB. points,:weights for y points
   x=. 1{:: p. p=.P y
   w=. 2% (-.*:x)**:(p..p)p.x
   x,:w
)

GaussLegendre =: 1 :0 NB. npoints function GaussLegendre (a,b)
:
   'x w'=.getpoints x
   -:(-~/y)* +/w* u -:((+/,-~/)y)p.x
)
