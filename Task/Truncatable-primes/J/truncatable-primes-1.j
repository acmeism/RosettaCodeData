selPrime=: #~ 1&p:
seed=: selPrime digits=: 1+i.9
step=: selPrime@,@:(,&.":/&>)@{@;
