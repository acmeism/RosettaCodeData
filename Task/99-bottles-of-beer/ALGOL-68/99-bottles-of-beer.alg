main:(
   FOR bottles FROM 99 TO 1 BY -1 DO
     printf(($z-d" bottles of beer on the wall"l$, bottles));
     printf(($z-d" bottles of beer"l$, bottles));
     printf(($"Take one down, pass it around"l$));
     printf(($z-d" bottles of beer on the wall"ll$, bottles-1))
   OD
)
