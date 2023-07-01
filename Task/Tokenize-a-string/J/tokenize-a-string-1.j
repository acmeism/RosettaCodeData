   s=: 'Hello,How,Are,You,Today'
   ] t=: <;._1 ',',s
+-----+---+---+---+-----+
|Hello|How|Are|You|Today|
+-----+---+---+---+-----+
   ; t,&.>'.'
Hello.How.Are.You.Today.

  '.' (I.','=s)}s  NB. two steps combined
Hello.How.Are.You.Today
