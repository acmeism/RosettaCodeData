/* REXX demonstrate uses of datatype() */
/* test values                         */
d.1=''
d.2='a23'
d.3='101'
d.4='123'
d.5='12345678901234567890'
d.6='abc'
d.7='aBc'
d.8='1'
d.9='0'
d.10='Walter'
d.11='ABC'
d.12='f23'
d.13='123'
/* supported options                   */
t.1='A'       /* Alphanumeric          */
t.2='B'       /* Binary                */
t.3='I'       /* Internal whole number */
t.4='L'       /* Lowercase             */
t.5='M'       /* Mixed case            */
t.6='N'       /* Number                */
t.7='O'       /* lOgical               */
t.8='S'       /* Symbol                */
t.9='U'       /* Uppercase             */
t.10='V'      /* Variable              */
t.11='W'      /* Whole number          */
t.12='X'      /* heXadecimal           */
t.13='9'      /* 9 digits              */

hdr=left('',20)
Do j=1 To 13
  hdr=hdr t.j
  End
hdr=hdr 'datatype(v)'
Say hdr
Do i=1 To 13
  ol=left(d.i,20)
  Do j=1 To 13
    ol=ol datatype(d.i,t.j)
    End
  ol=ol datatype(d.i)
  Say ol
  End
Say hdr
