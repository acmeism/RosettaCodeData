|=  n=@ud
=+  m=0
=+  o=(reap 1 '*')
|^  ?:  =(m n)  o
    $(m +(m), o (weld top bot))
++  gap  (fil 3 (pow 2 m) ' ')
++  top  (turn o |=(l=@t (rap 3 gap l gap ~)))
++  bot  (turn o |=(l=@t (rap 3 l ' ' l ~)))
--
