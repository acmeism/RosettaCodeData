ack=: c1`c1`c2`c3 @. (#.@,&*) M.
c1=: >:@]                        NB. if 0=x, 1+y
c2=: <:@[ ack 1:                 NB. if 0=y, (x-1) ack 1
c3=: <:@[ ack [ ack <:@]         NB. else,   (x-1) ack x ack y-1
