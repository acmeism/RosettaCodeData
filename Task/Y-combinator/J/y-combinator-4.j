   sr=. [ apply f.,&<                 NB. Self referring
   lv=. (((^:_1)b.)(`(<'0';_1)))(`:6) NB. Linear representation of a verb argument
   Y=. (&>)/lv(&sr) f.                NB. Y combinator
   Y=. 'Y'f.                          NB. Fixing it
