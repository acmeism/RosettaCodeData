option explicit
const pix="##"
const cl_on=16
const cl_mnum=15
randomize timer
const tlcr=2, tlcc=2
const maxdim =31
settitle "Conway's game of life"

dim a(31,31)

dim ans0:ans0=chr(27)&"["
dim gen,n
gen=0
paintframe
'init1      'objects
init2 400   'random

do
  n=nextgen
  toxy tlcr-1,tlcc+maxdim*2+4,gen & " " & n
  toxy tlcr,tlcc+maxdim*2+3,""
  gen=gen+1
loop until n=0

sub pause() wscript.stdout.write vbcrlf & "Press Enter":wscript.stdin.readline: end sub
sub settitle(s)  wscript.StdOut.Write chr(27)&"]0;"& s &chr(7):end sub
sub cls()  wscript.StdOut.Write ans0 &"2J"&ans0 &"?25l":end sub
sub toxy(r,c,s)  wscript.StdOut.Write ans0 & r & ";" & c & "f"  & s :end sub
function iif(a,b,c) if a then iif=b else iif=c end if :end function

sub init1
dim x
update 0,1,1,x:update 1,2,1,x:update 2,0,1,x:update 2,1,1,x:update 2,2,1,x
update 3,13,1,x:update 4,13,1,x:update 5,13,1,x
update 11,1,1,x:update 11,2,1,x: update 12,1,1,x:update 12,2,1,x
update 13,3,1,x:update 13,4,1,x: update 14,3,1,x:update 14,4,1,x
end sub

sub init2 (n)
dim i,r,c,x
for i=1 to n
   do
     r=cint(rnd*maxdim)
     c=cint(rnd*maxdim)
   loop until (a(r,c) and cl_on)=0
   update r,c,1,x
next
end sub

sub paintframe
  dim r,c,s
  const frame="@"
  cls
  'toxy 1,tlcc-1, "Conway's Game of Life"
  toxy tlcr-1,tlcc-1,string(maxdim*2+4,frame)
  s=frame&space(maxdim*2+2)&frame
  for r=0 to maxdim
    toxy tlcr+r,tlcc-1,s
  next
  toxy tlcr+maxdim+1,tlcc-1,string(maxdim*2+4,frame)
end sub

function nextgen()
  dim r,c,pre,cnt,a1,onoff,chg
  nextgen=0
  a1=a                                 'does a hard a copy of a
  for r=0 to maxdim
    for c=0 to maxdim
      if a1(r,c)then                'check only cells alive or having neighbors
        pre=a1(r,c) and cl_on
        cnt=a1(r,c) and cl_mnum
        'check life condition and update cell
        if pre<>0  and  (cnt<2 or cnt>3)  then
          update r,c,0,nextgen
        elseif pre=0  and cnt=3 then
          update r,c,1,nextgen
        end if
      end if
    next
   next
end function

sub update(r,c,onoff,nextgen)
'displays cell and update neighbors count in neighbors
dim cp,cm,rp,rm,inc,mask
   mask=iif(onoff,cl_on,0)
   a(r,c)= (a(r,c) and cl_mnum) or mask       'update cell
   toxy tlcr+r,tlcc+c*2,iif (onoff,pix,"  ")  'display cell
   cp=(c+1) and maxdim                 'wrap around
   cm=(c-1) and maxdim
   rp=(r+1) and maxdim
   rm=(r-1) and maxdim
   if onoff then inc=1 else inc=-1
   'update count in neighbors
   a(rp,cp)=(a(rp,cp) and cl_on) or ((a(rp,cp) and cl_mnum)+inc)
   a(rp,c)=(a(rp,c) and cl_on) or ((a(rp,c) and cl_mnum)+inc)
   a(rp,cm)=(a(rp,cm) and cl_on) or ((a(rp,cm) and cl_mnum)+inc)
   a(r,cp)=(a(r,cp) and cl_on) or ((a(r,cp) and cl_mnum)+inc)
   a(r,cm)=(a(r,cm) and cl_on) or ((a(r,cm) and cl_mnum)+inc)
   a(rm,cp)=(a(rm,cp) and cl_on) or ((a(rm,cp) and cl_mnum)+inc)
   a(rm,c)=(a(rm,c) and cl_on) or ((a(rm,c) and cl_mnum)+inc)
   a(rm,cm)=(a(rm,cm) and cl_on) or ((a(rm,cm) and cl_mnum)+inc)
   nextgen=nextgen+1
end sub
