frename=: 4 : 0
 if. x -: y do. return. end.
 if. IFUNIX do.
   hostcmd=. [: 2!:0 '('"_ , ] , ' || true)'"_
   hostcmd 'mv "',y,'" "',x,'"'
 else.
   'kernel32 MoveFileA i *c *c' 15!:0 y;x
 end.
)
