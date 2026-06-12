/* REXX */
Numeric digits 20
Say 'The continued fraction convergents (maximum 8 terms) for the following are:'
Call test "415/93",415/93
Call test "649/200",649/200
Call test "Square root of 2", rxCalcsqrt(2)
Call test "Square root of 5", rxCalcsqrt(5)
Call test "Golden ratio",(rxCalcsqrt(5)+1)/2
Exit

test:
Parse Arg text,x
size=8
cl=''
Do i=1 To size Until fractionPart<0.000000001
  parse Var x intPart '.'
  fractionPart = x - intPart
--Say i intPart fractionPart
  x=1/fractionPart
  cl=cl intPart
  End
a=0 1
b=1 0
s='['
Do While cl>''
  Parse Var cl c cl
  acopy=a
  a=b
  b=word(acopy,1)+c*word(b,1) word(acopy,2)+c*word(b,2)
  s=s||translate(b,'/',' ')
  If words(cl)>0 Then s=s', '
  End
Say right(text,20) '=>' s']'
Return
::REQUIRES rxMath Library
