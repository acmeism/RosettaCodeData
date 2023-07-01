nextPell=: , 1 2+/ .*_2&{. NB. pell, list extender
Pn=: (%:8) %~(1+%:2)&^ - (1-%:2)&^ NB. pell, closed form
Qn=: (1+%:2)&^ + (1-%:2)&^         NB. pell lucas, closed form
QN=: +: %&Pn ]                     NB. pell lucas, closed form
qn=: 2 * (+&Pn <:)                 NB. pell lucas, closed form
