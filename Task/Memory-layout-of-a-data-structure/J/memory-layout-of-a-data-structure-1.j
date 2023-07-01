default=: 0#~#|:'labels comments'=:|:(4 ({.@;:@{. ; }.)]);._2 {{)n
RD   Received data
TD   Transmitted data
DTR  Data terminal ready
SG   Signal ground
DSR  Data set ready
RTS  Request to send
CTS  Clear to send
RI   Ring indicator
}}

indices=: labels (i. ;: ::]) ]
ndx=: [ {~ [ indices ]
asgn=: {{ y (x indices m)} x }}
