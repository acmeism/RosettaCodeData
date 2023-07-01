$ gforth
Gforth 0.7.0, Copyright (C) 1995-2008 Free Software Foundation, Inc.
Gforth comes with ABSOLUTELY NO WARRANTY; for details type `license'
Type `bye' to exit
  ok
: f ( separator suffix prefix -- )  compiled
   pad place  2swap 2dup   compiled
   pad +place    compiled
   pad +place    compiled
   pad +place  compiled
   pad count ;  ok
  ok
 s" :" s" Code" s" Rosetta" f cr type
Rosetta::Code ok
