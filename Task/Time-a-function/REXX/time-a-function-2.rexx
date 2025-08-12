-- 7 Aug 2025
include Settings
arg count','prec
if count = '' then
   count = 1e7
if prec = '' then
   prec = 9
numeric digits prec

say 'TIME A FUNCTION'
say version
say
say 'Part 1: REXX clauses'
say
call Parameters
call DoLoop
call DoForLoop
call DoToLoop
call DoForByLoop
call DoToByLoop
say
call Tarra
call IntegerAssign
call IntegerAdd
call IntegerMultiply
call IntegerDivide1
call IntegerDivide2
call IntegerRemainder
call IntegerPower
say
call FloatAssign
call FloatAdd
call FloatMultiply
call FloatDivide1
call FloatDivide2
call FloatRemainder
call FloatPower
call FloatFormula
say
call StringFunctions
call NumericFunctions
call DateFunctions
call TimeFunctions
say
call FixedParseVar
call DynamicParseVar
call ParseValue
say
call NoOperation
say
call IfThen
call SelectWhen
say
call CallProc
call CallProcParms
call CallRout
call CallRoutParms
say
call Interpreting
say
call Output
call Input
say
call Stems
say
call Average
say
say 'Part 2: Profiler'
say
call Profiler 'ArcSin(X)',1/3
call Profiler 'Exp(X)',1/4
call Profiler 'Gamma(X)',1/5
call Profiler 'Ln(X)',1/6
call Profiler 'Pi()'
call Profiler 'Sin(X)',1/7
call Profiler 'Sqrt(X)',1/8
call Profiler 'X',1/9
call Profiler 'X**5-5/x-1',1/10
call Profiler 'Zeta(X)',1/11
return

Parameters:
start = date() time()
int1 = right(sqrt3(),prec%2); int2 = right(sqrt2(),prec%2)
if int2 > int1 then
   parse value int2 int1 with int1 int2
float1 = sqrt3()/1; float2 = sqrt2()/1
tarra = 0; totelaps = 0; totcount = 0
return

DoLoop:
call Time('r')
do count
end
call Measure 'Do',1
return

DoForLoop:
call Time('r')
do n = 1 for count
end
call Measure 'Do for',1
return

DoToLoop:
call Time('r')
do n = 1 to count
end
call Measure 'Do to',1
return

DoForByLoop:
call Time('r')
do n = 1 for count by 1
end
call Measure 'Do for by',1
return

DoToByLoop:
call Time('r')
do n = 1 to count by 1
end
call Measure 'Do to by',1
return

Tarra:
call Time('r')
do n = 1 to 1e8
end
tarra = Time('e')*count/1e8
return

IntegerAssign:
call Time('r')
do n = 1 to count
   a = int1
end
call Measure 'Integer assign',1
return

IntegerAdd:
call Time('r')
do n = 1 to count
   a = int1+int2
end
call Measure 'Integer +',1
return

IntegerMultiply:
call Time('r')
do n = 1 to count
   a = int1*int2
end
call Measure 'Integer *',1
return

IntegerDivide1:
call Time('r')
do n = 1 to count
   a = int1/int2
end
call Measure 'Integer /',1
return

IntegerDivide2:
call Time('r')
do n = 1 to count
   a = int1//int2
end
call Measure 'Integer //',1
return

IntegerRemainder:
call Time('r')
do n = 1 to count
   a = int1%int2
end
call Measure 'Integer %',1
return

IntegerPower:
call Time('r')
do n = 1 to count
   a = int1**2
end
call Measure 'Integer **',1
return

FloatAssign:
call Time('r')
do n = 1 to count
   a = float1
end
call Measure 'Float assign',1
return

FloatAdd:
call Time('r')
do n = 1 to count
   a = float1+float2
end
call Measure 'Float +',1
return

FloatMultiply:
call Time('r')
do n = 1 to count
   a = float1*float2
end
call Measure 'Float *',1
return

FloatDivide1:
call Time('r')
do n = 1 to count
   a = float1/float2
end
call Measure 'Float /',1
return

FloatDivide2:
call Time('r')
do n = 1 to count
   a = float1//float2
end
call Measure 'Float //',1
return

FloatRemainder:
call Time('r')
do n = 1 to count
   a = float1%float2
end
call Measure 'Float %',1
return

FloatPower:
call Time('r')
do n = 1 to count
   a = float1**2
end
call Measure 'Float **',1
return

FloatFormula:
call Time('r')
do n = 1 to count
   a = (float1+float2) + (float1*float2) + (float1/float2)
end
call Measure 'Float formula',1
return

StringFunctions:
a = 'This is the first text'; b = 'This is the second text'; c = float1
call Time('r')
do n = 1 to count
   t = a||b
   t = Abbrev('text',a)
   t = Center(a,100)
   t = Compare(a,b)
   t = Copies(a,3)
   t = Delstr(a,5,10)
   t = Delword(a,2,3)
   t = Format(c,1,5)
   t = Insert(a,b,10)
   t = Lastpos('text',a)
   t = Left(a,10)
   t = Length(a)
   t = Overlay('xxx',a,3)
   t = Pos('text',a)
   t = Reverse(a)
   t = Right(a,10)
   t = Space(a)
   t = Strip(a)
   t = Substr(a,5,10)
   t = Subword(a,2,2)
   t = Translate(a,'xxx','the')
   t = Verify(a,'the')
   t = Word(a,3)
   t = Wordindex(a,3)
   t = Wordlength(a,3)
   t = Wordpos('the',a)
   t = Words(a)
   t = Xrange('a','z')
end
call Measure 'String functions',28
return

NumericFunctions:
call Time('r')
do n = 1 to count
   t = Abs(float1)
   t = Max(float1,float2)
   t = Min(float1,float2)
   t = Random()
   t = Sign(float1)
   t = Trunc(float1)
   t = Digits()
end
call Measure 'Numeric functions',7
return

DateFunctions:
call Time('r')
do n = 1 to count
   t = Date('b')
   t = Date('d')
   t = Date('e')
   t = Date('m')
   t = Date('n')
   t = Date('o')
   t = Date('s')
   t = Date('u')
   t = Date('w')
end
call Measure 'Date functions',9
return

TimeFunctions:
call Time('r')
do n = 1 to count
   t = Time('c')
   t = Time('e')
   t = Time('h')
   t = Time('l')
   t = Time('m')
   t = Time('n')
   t = Time('s')
end
call Measure 'Time functions',7
return

FixedParseVar:
t = '1,2,3,4,5,6,7,8,9,10'
call Time('r')
do n = 1 to count
   parse var t rec1 ','  rec2 ','  rec3 ','  rec4 ','  rec5 ','  rec6 ','  rec7 ','  rec8 ','  rec9 ','  rec10
end
call Measure 'Fixed parse var',1
return

DynamicParseVar:
t = '1,2,3,4,5,6,7,8,9,10'
call Time('r')
do n = 1 to count
   do y = 1 to 10
      parse var t rec.y ',' t
   end
end
call Measure 'Dynamic parse var',1
return

Parsevalue:
call Time('r')
do n = 1 to count
   parse value float1 float2 with a,b
end
call Measure 'Parse value',1
return

NoOperation:
call Time('r')
do n = 1 to count
   nop
end
call Measure 'No operation',1
return

IfThen:
call Time('r')
do n = 1 to count
   if float1 = float1 then nop
end
call Measure 'If then',1
return

SelectWhen:
call Time('r')
do n = 1 to count
   select
      when float1 = float1 then nop
   end
end
call Measure 'Select when',1
return

CallProc:
call Time('r')
do n = 1 to count
   call Proc1
end
call Measure 'Call procedure',1
return

CallProcParms:
call Time('r')
do n = 1 to count
   call Proc2 1,2,3
end
call Measure 'Call procedure arg',1
return

CallRout:
call Time('r')
do n = 1 to count
   call Rout1
end
call Measure 'Call routine',1
return

CallRoutParms:
call Time('r')
do n = 1 to count
   call Rout2 1,2,3
end
call Measure 'Call routine arg',1
return

Proc1:
procedure
return

Proc2:
procedure
arg a,b,c
return

Rout1:
return

Rout2:
arg a,b,c
return

Interpreting:
a = 'nop'
call Time('r')
do n = 1 to count
   interpret a
end
call Measure 'Interpret',1
return

Output:
file = 'dummy.txt'
call Lineout file,,1
call Time('r')
do n = 1 to count
   call Lineout file,'Just a small line'
end
call Measure 'Output',1
return

Input:
file = 'dummy.txt'
call Time('r')
do n = 1 to count
   t = Linein(file)
end
call Measure 'Input',1
return

Stems:
call Time('r')
do n = 1 to count
   stem.n = n
end
call Measure 'Stem processing',1
return

Average:
totelaps = 1e6*totelaps/totcount
say Left('Average',20) round(totelaps,3) 'microsec ='  round(1/totelaps,1) 'million clauses/sec'
say
say Left('Start run',20) start
say Left('Clauses processed',20) round(totcount/1e6,1) 'million'
say Left('Stop run',20) date() time()
return

Measure:
parse arg measure,clauses
elaps = Time('e')-tarra
if elaps > 0 then do
   totelaps = totelaps+elaps; totcount = totcount+count*clauses
   elaps = 1e6*elaps/(count*clauses)
   say Left(measure,20) round(elaps,3) 'microsec ='  round(1/elaps,1) 'million clauses/sec'
end
else
   say Left(measure,20) 'cannot perform measure, please try a higher count'
return

Profiler:
arg ff,xx,yy,zz
rr=Profile(ff,xx,yy,zz)
say left(ff,10) 'takes' right(word(rr,2),4) 'microsec, x =' xx', f =' word(rr,1)/1
return

include Math
