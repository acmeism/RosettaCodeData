step         =: 0.6 > ?@0:
attemptClimb =: [: <:`>:@.step 0:
isNotUpOne   =: -.@(+/@])

step_up=: (] , attemptClimb)^:isNotUpOne^:_
