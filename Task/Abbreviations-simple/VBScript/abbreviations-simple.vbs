option explicit

function iif(c,t,f) if c then iif=t else iif=f end if: end function
function usrin(pr)  wscript.stdout.write vbcrlf &pr &": ":usrin= wscript.stdin.readline:end function

sub do_abbrev
  dim j, sm,n,n0,a
  for each j in m
    sm=trim(lcase(j.submatches(0)))
    n0=iif (j.submatches(1)="",1,  j.submatches(1))
    n=1
    do
      a=left(sm,n)
      if not d.exists(a)  then
        d.add a,sm
      else
        if len(a)=len(sm) then
           d(a)=sm
        elseif len(d(a))>len(a) then
          d(a)=null
        end if
      end if
      n=n+1
    loop until n>len(sm)
  next
end sub
'output sorted

sub display
  dim d2,k,j,kk,mm
  set d2=createobject("Scripting.dictionary")
  for each k in d
      kk=d(k)
    if not isnull(kk) then
     if not d2.exists(kk) then
       d2.add kk,k
     else
       d2(kk)= d2(kk) & " " & k
     end if
     end if
  next
  for each j in m
    mm=trim(lcase(j.submatches(0)))
    wscript.echo left(mm&space(15),15),d2(mm)
  next
  wscript.echo
  set d2=nothing
end sub

sub test
  wscript.echo vbcrlf&"test:"
  dim a,i,k,s1
  do
    s1= lcase(usrin("Command?"))
    if trim(s1)="" then wscript.quit
    a=split(trim(s1)," ")
    for i=0 to ubound(a)
      if a(i)<>"" then
        wscript.stdout.write iif (d.exists(a(i)), ucase(d(a(i)))," **ERROR**")& " "
      end if
    next
  loop
end sub

'main program
dim s:s=_
   "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 "&_
   "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate "&_
   "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 "&_
   "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load "&_
   "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 "&_
   "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 "&_
   "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left "&_
   "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 "
dim m,d

'use regexp to separate input
with new regexp
 .pattern="([a-z]+?)\s+(\d?)"
 .global=true
 .ignorecase=true
 set m=.execute(s)
end with

set d=createobject("Scripting.dictionary")
do_abbrev
'display
test
