rk4=: adverb define
 'Y0 a b h'=. 4{. y
 T=. a + i.@>:&.(%&h) b-a
 (,. [: h&(u nextY)@,/\. Y0 ,~ }.)&.|. T
)

NB. nextY a Calculate Yn+1 of a function using Runge-Kutta method
NB. y is: 2-item numeric list of time t and y(t)
NB. u is: function to use
NB. x is: step size
NB. eg: 0.001 fyp nextY 0 1
nextY=: adverb define
:
 tableau=. 1 0.5 0.5, x * u y
 ks=. (x * [: u y + (* x&,))/\. tableau
 ({:y) + 6 %~ +/ 1 2 2 1 * ks
)
