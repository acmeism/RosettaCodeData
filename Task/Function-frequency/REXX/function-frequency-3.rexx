-- 21 Feb 2026
include Setting
parse arg program

say 'FUNCTION FREQUENCY'
say version
call ReadSource
call CleanSource
call CollectInvokes
call SortSt 'invo.'
call ReportInvokes
call Timer
exit

ReadSource:
-- Read all lines in a stem
if program='' then
   program='FuncFreq.rex'
else
   program=program'.rex'
say 'Invoke frequencies for program' program
say
call Stream program,'c','open read'
srce.=0; n=0
do while Lines(program)
   record=LineIn(program)
   n=n+1; srce.n=record
end
srce.0=n
call Stream program,'c','close'
return

CleanSource:
-- Erase all characters that are (in this order):
-- within a '' literal or a "" literal
-- within a /*...*/ comment block
-- after -- ... comment
-- not allowed in names
cleanc=0
p1=0; q1=0
do i = 1 to srce.0
   cleanl=0
   s=srce.i; k=Length(s)
   do j = 1 to k
-- Substring for literals
      p1=SubStr(s,j,1)
-- Erase literal
      if p1 = "'" | p1 = '"' then do
         if cleanl then do
            s=Overlay(' ',s,j)
            if p1 = q1 then
               cleanl=0
         end
         else do
            q1=p1; cleanl=1
         end
      end
      if cleanl then
         s=Overlay(' ',s,j)
   end j
-- Substring for comments
      p2=SubStr(s,j,2)
-- Erase block /*...*/ comment
      if p2 = '/*' then
         cleanc=1
      else do
         if p2 = '*/' then do
            s=Overlay(' ',s,j,2)
            cleanc=0
         end
      end
      if cleanc then do
         s=Overlay(' ',s,j)
         iterate j
      end
-- Erase -- ... comment
      if p2 = '--' then do
         s=Overlay(' ',s,j,k)
         leave j
      end
-- Erase all characters not allowed in names
   s=Translate(s,'             ','+-*|<>,;=/\%)')
   srce.i=s
end i
return

CollectInvokes:
-- Collect invocations 'Name()' or 'call Name'
invo.=0; v=0
do i = 1 to srce.0
   s=srce.i
-- Parse words
   wrds.=0; n=0
   do until s = ''
      n=n+1; parse var s wrds.n s
   end
-- Find invocations
   wrds.0=n
   do j = 1 to wrds.0
      w=wrds.j
-- Call Name
      if Upper(w) = 'CALL' then do
         k=j+1; v=v+1; invo.v=wrds.k
      end
-- Name()
      else do
         p1=1; p2=Pos('(',w)
         do while p2 > 0
            a=SubStr(w,p1,p2-p1)
            if a <> '' then do
               v=v+1; invo.v=SubStr(w,p1,p2-p1)
            end
            p1=p2+1; p2=Pos('(',w,p1)
         end
      end
   end j
end i
invo.0=v
return

ReportInvokes:
-- Aggregate and report
p=invo.1; n=1
do i = 2 to invo.0
   v = invo.i
   if v = p then
      n=n+1
   else do
      say Right(n,3) p
      p=v; n=1
   end
end i
say Right(n,3) p
say
return

-- SortSt; Timer
include Math
