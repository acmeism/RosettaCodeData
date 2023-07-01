option explicit

function do_brackets(bal)
  dim s,i,cnt,r
  if bal then s="[":cnt=1 	else   s="":cnt=0
  for i=1 to 20
   if (rnd>0.7) then r=not r
   if not r then
     s=s+"[" :cnt=cnt+1
   else
    if not bal or (bal and cnt>0) then s=s+"]":cnt=cnt-1
  end if	
  next
  if bal and cnt<>0 then s=s&string(cnt,"]")
  if not bal and cnt=0 then s=s&"]"
  do_brackets=s
end function

function isbalanced(s)
  dim s1,i,cnt: cnt=0
  for i=1 to len(s)
    s1=mid(s,i,1)
    if s1="[" then cnt=cnt+1
    if s1="]" then cnt=cnt-1
    if cnt<0 then isbalanced=false:exit function
  next
  isbalanced=(cnt=0)
end function

function iif(a,b,c): if a then iif=b else iif=c end if : end function

randomize timer
dim i,s,bal,bb
for i=1 to 10
  bal=(rnd>.5)
  s=do_brackets(bal)
  bb=isbalanced(s)
  wscript.echo  iif (bal,"","un")& "balanced string " &vbtab _
  & s & vbtab & " Checks as " & iif(bb,"","un")&"balanced"
next
