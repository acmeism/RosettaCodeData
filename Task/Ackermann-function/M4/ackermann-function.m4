define(`ack',`ifelse($1,0,`incr($2)',`ifelse($2,0,`ack(decr($1),1)',`ack(decr($1),ack($1,decr($2)))')')')dnl
ack(3,3)
