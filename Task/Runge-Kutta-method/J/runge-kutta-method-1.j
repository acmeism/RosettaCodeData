NB.*rk4 a Solve function using Runge-Kutta method
NB. y is: y(ta) , ta , tb , tstep
NB. u is: function to solve
NB. eg: fyp rk4 1 0 10 0.1
rk4=: adverb define
 'Y0 a b h'=. 4{. y
 T=. a + i.@>:&.(%&h) b - a
 Y=. Yt=. Y0
 for_t. }: T do.
   ty=. t,Yt
   k1=. h * u ty
   k2=. h * u ty + -: h,k1
   k3=. h * u ty + -: h,k2
   k4=. h * u ty + h,k3
   Y=. Y, Yt=. Yt + (%6) * 1 2 2 1 +/@:* k1, k2, k3, k4
 end.
T ,. Y
)
