   spkln =: verb define
   	y spkln~ 4 u:16b2581+i.8  NB.  ▁▂▃▄▅▆▇█
   :
   	'MIN MAX' =. (<./ , >./) y
   	N         =. # x
   	x {~ <. (N-1) * (y-MIN) % MAX-MIN
   )
