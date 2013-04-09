/*REXX program demonstrates array usage: sparse and disjointed. */
yyy = -55
a.yyy = 1e9                     /*REXX must use this mechanism for neg idx.*/

a.1=1000
a.2=2000.0001
a.7 = 7000
a.2012 = 'out here in left field.'
a.cat='civet, but not a true cat --- belonging to the family Viverridae'
a.civet="A.K.A.: toddycats"

/*------------------------------------------------------------------------
  Array elements need not be continous (nor even defined).   They can hold
  any nanner of numbers, or strings (which can include any characters,
  including null or '00'x characters).

  Array elements need not be numeric, as the above code demonstrates.
  Indeed, the element "name" can be ANYTHING, even non-displayable
  characters.   To illustrate:
--------------------------------------------------------------------------*/

stuff=')g.u.t.s(  or  Â½ of an intestine!'
a.stuff=44

/*--------------------------------------------------------------
   where the element name has special characters, blanks, and
   the glyph of one-half, as well as the symbol used in REXX to
   indentify stemmed arrays (the period).
----------------------------------------------------------------*/
