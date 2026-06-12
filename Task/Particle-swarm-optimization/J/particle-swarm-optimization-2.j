   require 'trig'
   mccormick =: sin@(+/) + *:@(-/) + 1 + _1.5 2.5 +/@:* ]

   state =: pso_init _1.5 _3 ; 4 4 ; 0 0.6 0.3; 100
Min: _1.5 _3
Max: 4 4
omega, phip, phig: 0 0.6 0.3
nParticles: 100

   state =: (mccormick pso)^:40 state
   reportState state
Iteration: 40
GlobalBestPosition: _0.547399 _1.54698
GlobalBestValue: _1.91322
