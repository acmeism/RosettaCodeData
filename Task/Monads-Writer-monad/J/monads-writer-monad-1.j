W   =: {{u;n"_}}                    NB. create Kleisli fns (a -> Writer c b)
unit=: ;'Initial value: ',,@":
bind=: {{b;w,LF,W,' -> ',,":b['b W'=.u a['a w'=.y}}
comp=: [: > {{<x`:6 bind>y}}/@(,<)  NB. multi-compose
