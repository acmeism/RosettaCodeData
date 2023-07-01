   f=: 6j2&":   NB. formatting verb

   sin=: 1&o.   NB. verb to evaluate circle function 1, the sine

   add_noise=: ] + (* (_0.5 + 0 ?@:#~ #))   NB. AMPLITUDE add_noise SIGNAL

   f RADIANS=: o.@:(%~ i.@:>:)5  NB. monadic circle function is  pi times
  0.00  0.63  1.26  1.88  2.51  3.14

   f SINES=: sin RADIANS
  0.00  0.59  0.95  0.95  0.59  0.00

   f NOISY_SINES=: 0.1 add_noise SINES
 _0.01  0.61  0.91  0.99  0.60  0.02

   A=: (^/ i.@:#) RADIANS  NB. A is the quintic coefficient matrix

   NB. display the equation to solve
   (f A) ; 'x' ; '=' ; f@:,. NOISY_SINES
┌────────────────────────────────────┬─┬─┬──────┐
│  1.00  0.00  0.00  0.00  0.00  0.00│x│=│ _0.01│
│  1.00  0.63  0.39  0.25  0.16  0.10│ │ │  0.61│
│  1.00  1.26  1.58  1.98  2.49  3.13│ │ │  0.91│
│  1.00  1.88  3.55  6.70 12.62 23.80│ │ │  0.99│
│  1.00  2.51  6.32 15.88 39.90100.28│ │ │  0.60│
│  1.00  3.14  9.87 31.01 97.41306.02│ │ │  0.02│
└────────────────────────────────────┴─┴─┴──────┘

   f QUINTIC_COEFFICIENTS=: NOISY_SINES %. A   NB. %. solves the linear system
 _0.01  1.71 _1.88  1.48 _0.58  0.08

   quintic=: QUINTIC_COEFFICIENTS&p.  NB. verb to evaluate the polynomial

   NB. %. also solves the least squares fit for overdetermined system
   quadratic=: (NOISY_SINES %. (^/ i.@:3:) RADIANS)&p.  NB. verb to evaluate quadratic.
   quadratic
_0.0200630695393961729 1.26066877804926536 _0.398275112136019516&p.

   NB. The quintic is agrees with the noisy data, as it should
   f@:(NOISY_SINES ,. sin ,. quadratic ,. quintic) RADIANS
 _0.01  0.00 _0.02 _0.01
  0.61  0.59  0.61  0.61
  0.91  0.95  0.94  0.91
  0.99  0.95  0.94  0.99
  0.60  0.59  0.63  0.60
  0.02  0.00  0.01  0.02

   f MID_POINTS=: (+ -:@:(-/@:(2&{.)))RADIANS
 _0.31  0.31  0.94  1.57  2.20  2.83

   f@:(sin ,. quadratic ,. quintic) MID_POINTS
 _0.31 _0.46 _0.79
  0.31  0.34  0.38
  0.81  0.81  0.77
  1.00  0.98  1.00
  0.81  0.83  0.86
  0.31  0.36  0.27
