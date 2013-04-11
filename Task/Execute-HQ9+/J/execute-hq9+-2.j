H=: smoutput bind 'Hello, world!'
Q=: smoutput @ [
hq9=: smoutput @: (beer"0) bind (1+i.-99)
hqp=: (A=:1)1 :'0 0$A=:A+m[y'@]

hq9p=: H`H`Q`Q`hq9`hqp@.('HhQq9+' i. ])"_ 0~
