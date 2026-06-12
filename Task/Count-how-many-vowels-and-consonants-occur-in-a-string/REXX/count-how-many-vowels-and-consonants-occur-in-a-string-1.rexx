/* REXX */
Parse Arg s
If s='' Then
  s='Forever Wren programming language'
con='BCDFGHJKLMNPQRSTVWXYZ'
vow='AEIOU'
su=translate(s)             /* translate to uppercase             */
suc=su
sx=''                       /* eliminate duplicate characters     */
Do While suc<>''
  Parse Var suc c +1 suc
  If pos(c,sx)=0 Then sx=sx||c
  End
Say s                       /* show input string                  */
Call count su               /* count all consonants and vowels    */
Call count sx,'distinct'    /* count unique consonants and vowels */
Exit
count:
Parse Arg s,tag
sc=translate(s,copies('+',length(con))copies(' ',256),con||xrange('00'x,'ff'x))
sv=translate(s,copies('+',length(vow))copies(' ',256),vow||xrange('00'x,'ff'x))
Say length(space(sc,0)) tag 'consonants,' length(space(sv,0)) tag 'vowels'
Return
