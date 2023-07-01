   require 'files'
   'I D' =: (8 ; 14+i.19) {"1 &.> <'m' fread 'licenses.txt' NB.  read file as matrix, select columns
   lu    =:  +/\ _1 ^ 'OI' i. I                             NB.  Number of licenses in use at any given time
   mx    =:  (I.@:= >./) lu                                 NB.  Indicies of maxima

   NB.  Output results
   (mx { D) ,~ 'Maximum simultaneous license use is ' , ' at the following times:' ,~ ": {. ,mx { lu
