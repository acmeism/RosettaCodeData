/* REXX */
Parse arg str                         /*obtain optional arguments from the CL*/
if str==''  then str= 'gHHH5YY++///\' /*Not specified?  Then use the default.*/
input=str
x=''
cp=''
result=''
Do While str<>''
  Parse Var str c +1 str
  If c==cp Then x=x||c
  Else Do
    If x>>'' Then
      result=result||x', '
    x=c
    End
  cp=c
  End
result=result||x
say '      input string: '    input
say '     output string: '    result
