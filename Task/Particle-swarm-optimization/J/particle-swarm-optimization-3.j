   michalewicz =: 3 : '- +/ (sin y) * 20 ^~ sin (>: i. #y) * (*:y) % pi'
   michalewicz =: [: -@(+/) sin * 20 ^~ sin@(pi %~ >:@i.@# * *:)  NB. tacit equivalent

   state =: pso_init 0 0 ; (pi,pi) ; 0.3 0.3 0.3; 1000
Min: 0 0
Max: 3.14159 3.14159
omega, phip, phig: 0.3 0.3 0.3
nParticles: 1000

   state =: (michalewicz pso)^:30 state
   reportState state
Iteration: 30
GlobalBestPosition: 2.20296 1.57083
GlobalBestValue: _1.8013
