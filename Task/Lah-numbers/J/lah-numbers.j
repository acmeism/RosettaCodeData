NB. use:   k lah n
lah=: ! :(!&<: * %&!~)&x:  NB. `%~' is shorter than `*inv'

NB. wory_lah translates lah to algebraic English.
Monad =: :[:  NB. permit only a y argument
Dyad =: [: :  NB. require x and y arguments
but_1st =: &
decrement =: <: Monad

NB. ! means either factorial or combinations (just as - means negate or subtract)
factorial =: ! Monad
combinations =: ! Dyad

into =: *inv Dyad
times =: *  Dyad
extend_precision =: x: Monad
wordy_lah =: ((combinations but_1st decrement) times (into but_1st factorial))but_1st extend_precision Dyad
