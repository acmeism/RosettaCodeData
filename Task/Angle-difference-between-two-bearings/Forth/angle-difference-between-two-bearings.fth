: Angle-Difference-stack ( b1 b2 - a +/-180)
\ Algorithm  with stack manipulation without branches ( s. Frotran Groovy)
     fswap f-                   \ Delta angle
     360e fswap fover fmod      \ mod 360
     fover 1.5e f* f+           \ +   540
     fover fmod                 \ mod 360
     fswap f2/  f-              \ -   180
;
: Angle-Difference-const  ( b1 b2 - a +/-180)
\ Algorithm  without  Branches ( s. Fotran Groovy)
     fswap f-
     360e  fmod
     540e  f+
     360e fmod
     180e  f-
;

\  Test Word  for  requested tests
: test-ad    ( b1 b2 -- )
   fover fover
   Angle-Difference-stack  f.
   Angle-Difference-const  f.
;
