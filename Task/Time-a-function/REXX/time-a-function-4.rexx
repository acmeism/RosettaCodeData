Main:
call Parameters
call DoToLoops
call DoForLoops
call Tarra
call IntegerAssign
call IntegerAdd
call IntegerSubtract
call IntegerMultiply
call IntegerDivide1
call IntegerDivide2
call IntegerRemainder
call IntegerPower
call FloatingAssign
call FloatingAdd
call FloatingSubtract
call FloatingMultiply
call FloatingDivide1
call FloatingDivide2
call FloatingRemainder
call FloatingPower
call Formula
call StringFunctions
call NumericFunctions
call FixedParseVar
call DynamicParseVar
call NoOperation
call IfThen
call SelectWhen
call IfElseIf
call CallProc
call CallProcParms
call CallRout
call CallRoutParms
call DateTime
call PushPullQueued
call Interpreting
call Output
call Input
call StemProcessing
return

Parameters:
arg count digit
if count = '' then
   count = 1e6
if digit = '' then
   digit = 9
numeric digits digit
parse version version
say 'Version' version
say 'Using loop counter' count/1e6 'million and' digits() 'digits'
say
tarra = 0
call time('r')
return

DoToLoops:
call time('r')
do x = 1 to count*10
end
call Measure 'Do ... to ...',10
return

DoForLoops:
call time('r')
do x = 1 for count*10
end
call Measure 'Do ... for ...',10
return

Tarra:
call time('r')
do x = 1 to count*10
end
tarra = time('e')/10
return

IntegerAssign:
call time('r')
do x = 1 to count*10
   a = 123
end
call Measure 'Integer assign',10
return

IntegerAdd:
call time('r')
do x = 1 to count*10
   a = x+123
end
call Measure 'Integer +',10
return

IntegerSubtract:
call time('r')
do x = 1 to count*10
   a = x-123
end
call Measure 'Integer -',10
return

IntegerMultiply:
call time('r')
do x = 1 to count*10
   a = x*123
end
call Measure 'Integer *',10
return

IntegerDivide1:
call time('r')
do x = 1 to count*10
   a = 123/3
end
call Measure 'Integer /',10
return

IntegerDivide2:
call time('r')
do x = 1 to count*10
   a = x//123
end
call Measure 'Integer //',10
return

IntegerRemainder:
call time('r')
do x = 1 to count*10
   a = x%123
end
call Measure 'Integer %',10
return

IntegerPower:
call time('r')
do x = 1 to count*10
   a = 123**2
end
call Measure 'Integer **',10
return

FloatingAssign:
call time('r')
do x = 1 to count*10
   a = 1.23
end
call Measure 'Floating assign',10
return

FloatingAdd:
call time('r')
do x = 1 to count*10
   a = x+1.23
end
call Measure 'Floating +',10
return

FloatingSubtract:
call time('r')
do x = 1 to count*10
   a = x-1.23
end
call Measure 'Floating -',10
return

FloatingMultiply:
call time('r')
do x = 1 to count*10
   a = x*1.23
end
call Measure 'Floating *',10
return

FloatingDivide1:
call time('r')
do x = 1 to count*10
   a = x/1.23
end
call Measure 'Floating /',10
return

FloatingDivide2:
call time('r')
do x = 1 to count*10
   a = x//1.23
end
call Measure 'Floating //',10
return

FloatingRemainder:
call time('r')
do x = 1 to count*10
   a = x%1.23
end
call Measure 'Floating %',10
return

FloatingPower:
call time('r')
do x = 1 to count*10
   a = 1.23**2
end
call Measure 'Floating **',10
return

Formula:
call time('r')
do x = 1 to count
   a = ( (x+1.23) * (x-1.23) ) / ( (x*1.23) * (x/1.23) )
end
call Measure 'Formula',1
return

StringFunctions:
a = 'this is the first text'; b = 'this is the second text'; c = 1.23
call time('r')
do x = 1 to count
   t = a||b
   t = abbrev('text',a)
   t = center(a,100)
   t = compare(a,b)
   t = copies(a,3)
   t = delstr(a,5,10)
   t = delword(a,2,3)
   t = format(c,1,2)
   t = insert(a,b,10)
   t = lastpos('text',a)
   t = left(a,10)
   t = length(a)
   t = overlay('paul',a,4)
   t = pos('text',a)
   t = reverse(a)
   t = right(a,10)
   t = space(a)
   t = strip(a)
   t = substr(a,5,10)
   t = subword(a,2,2)
   t = translate(a,'one','the')
   t = verify(a,'the')
   t = word(a,3)
   t = wordindex(a,3)
   t = wordlength(a,3)
   t = wordpos('is the',a)
   t = words(a)
   t = xrange('a','z')
end
call Measure 'String functions',28
return

NumericFunctions:
a = -1.23; b = 1.23
call time('r')
do x = 1 to count
   t = abs(a)
   t = max(a,b)
   t = min(a,b)
   t = random()
   t = sign(a)
   t = trunc(b)
   t = digits()
end
call Measure 'Numeric functions',7
return

FixedParseVar:
t = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20'
call time('r')
do x = 1 to count
   parse var t rec1 ','  rec2 ','  rec3 ','  rec4 ','  rec5 ','  rec6 ','  rec7 ','  rec8 ','  rec9 ','  rec10 ',',
               rec11 ',' rec12 ',' rec13 ',' rec14 ',' rec15 ',' rec16 ',' rec17 ',' rec18 ',' rec19 ',' rec20 ','
end
call Measure 'Fixed parse var',1
return

DynamicParseVar:
t = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20'
call time('r')
do x = 1 to count
   do y = 1 to 20
      parse var t rec.y ',' t
   end
end
call Measure 'Dynamic parse var',1
return

NoOperation:
call time('r')
do x = 1 to count*10
   nop
end
call Measure 'No operation',10
return

IfThen:
a = 1
call time('r')
do x = 1 to count
   if a = 1 then nop
   if a = 2 then nop
   if a <> 1 then nop
   if a <> 2 then nop
   if a < 0 then nop
   if a < 2 then nop
   if a > 0 then nop
   if a > 2 then nop
end
call Measure 'If ...then ...',8
return

SelectWhen:
a = 2
call time('r')
do x = 1 to count
   select
      when a = 1 then nop
      when a = 2 then nop
      when a = 3 then nop
   end
   select
      when a <> 2 then nop
      when a <> 1 then nop
      when a <> 0 then nop
   end
   select
      when a > 2 then nop
      when a > 1 then nop
      when a > 0 then nop
   end
   select
      when a < 2 then nop
      when a < 3 then nop
      when a < 4 then nop
   end
end
call Measure 'Select ... when ...',8
return

IfElseIf:
a = 2
call time('r')
do x = 1 to count
   if a = 1 then nop
   else if a = 2 then nop
   else if a = 3 then nop
   if a <> 2 then nop
   else if a <> 1 then nop
   else if a <> 0 then nop
   if a > 2 then nop
   else if a > 1 then nop
   else if a > 0 then nop
   if a < 2 then nop
   else if a < 3 then nop
   else if a < 4 then nop
end
call Measure 'If ... else if ...',8
return

CallProc:
call time('r')
do x = 1 to count
   call Proc1
end
call Measure 'Call procedure',1
return

CallProcParms:
call time('r')
do x = 1 to count
   call Proc2 1,2,3
end
call Measure 'Call procedure with parms',1
return

CallRout:
call time('r')
do x = 1 to count
   call Rout1
end
call Measure 'Call routine',1
return

CallRoutParms:
call time('r')
do x = 1 to count
   call Rout2 1,2,3
end
call Measure 'Call routine with parms',1
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

DateTime:
call time('r')
do x = 1 to count
   t = date('b')
   t = date('d')
   t = date('e')
   t = date('m')
   t = date('n')
   t = date('o')
   t = date('s')
   t = date('u')
   t = date('w')
   t = time('c')
   t = time('e')
   t = time('h')
   t = time('l')
   t = time('m')
   t = time('n')
   t = time('s')
end
call Measure 'Date and time',16
return

PushPullQueued:
a = 123.45
call time('r')
do x = 1 to count
   push a
   b = queued()
   pull a
end
call Measure 'Push, pull and queued',3
return

Interpreting:
a = 'nop'
call time('r')
do x = 1 to count
   interpret a
end
call Measure 'Interpret',1
return

Output:
file = '\temp\perf.txt'
call lineout file,,1
call time('r')
do x = 1 to count
   call lineout file,'sequence number of this record is' x
end
call Measure 'Output',1
return

Input:
file = '\temp\perf.txt'
call time('r')
do x = 1 to count
   t = linein(file)
end
call Measure 'Input',1
return

StemProcessing:
call time('r')
do x = 1 to count
   stem.x.x.x = 1.23
end
call Measure 'Stem processing',1
return

Measure:
parse arg measure,clauses
elaps = time('e')-tarra
if elaps > 0 then do
   say left(measure,25) format((count*clauses)/(1e6*elaps) ,3,1) 'million clauses/sec'
end
else
   say left(measure,25) 'loop counter too low, cannot perform measure'
return
