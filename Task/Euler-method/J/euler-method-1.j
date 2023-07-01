NB.*euler a Approximates Y(t) in Y'(t)=f(t,Y) with Y(a)=Y0 and t=a..b and step size h.
euler=: adverb define
 'Y0 a b h'=. 4{. y
 t=. i.@>:&.(%&h) b - a
 Y=. (+ h * u)^:(<#t) Y0
 t,.Y
)

ncl=: _0.07 * -&20  NB. Newton's Cooling Law
