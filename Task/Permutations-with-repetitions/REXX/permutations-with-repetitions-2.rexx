/* REXX ***************************************************************
* Arguments and output as in REXX version 1 (for the samples shown there)
* For other elements (such as 11 2), please specify a separator
* Translating 10, 11, etc. to A, B etc. is left to the reader
* 12.05.2013 Walter Pachl
* 12-05-2013 Walter Pachl take care of bunch<=0 and other oddities
**********************************************************************/
Parse Arg things bunch sep names
If datatype(things,'W') & datatype(bunch,'W') Then
  Nop
Else
  Call exit 'First two arguments must be integers >0'
If things='' Then n=3; Else n=things
If bunch=''  Then m=2; Else m=bunch
If things<=0 Then Call exit 'specify a positive number of things'
If bunch<=0 Then Call exit 'no permutations with' bunch 'elements!'

Select
  When sep='' Then ss=''''''
  When datatype(sep)='NUM' Then ss=''''copies(' ',sep)''''
  Otherwise ss=''''sep''''
  End
Do i=1 To n
  If names<>'' Then
    Parse Var names e.i names
  Else
    e.i=i
  End
a='p=0;'; Do i=1 To m; a=a||'Do p'i'=1 To n;'; End
a=a||'ol=e.p1'
          Do i=2 To m; a=a||'||'ss'||e.p'i; End
a=a||'; say ol; p=p+1;'
          Do i=1 To m; a=a||'end;'; End
a=a||'Say' p 'permutations'
/* Say a */
Interpret a
