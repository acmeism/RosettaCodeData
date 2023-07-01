require'plot'
N=:0.01*i.629
O=: [: j./ 1 2 o./ ]

delay=:6!:3    NB. "sleep"
clock=: [: plot (O N),N*/~0.07 0.11 0.15(*O) 2r24p1 2r60p1 2r60p1*_3{.6!:0 bind ''
delay@1:@clock^:9e99''
