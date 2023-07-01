'----------------15 game-------------------------------------
'WARNING: this script uses ANSI escape codes to position items on console so
'it won't work in Windows from XP to 8.1 where Microsoft removed ANSI support...
'Windows 10, 11 or 98 are ok!!!

option explicit
const maxshuffle=100 'level

dim ans0:ans0=chr(27)&"["
dim anscls:anscls=ans0 & "2J"

dim dirs:dirs=array(6,-1,-6,1)
dim a:a=array(-1,-1,-1,-1,-1,-1,_
              -1, 1, 2, 3, 4,-1,_
              -1, 5, 6, 7, 8,-1,_
              -1, 9,10,11,12,-1,_
              -1,13,14,15, 0,-1,_
              -1,-1,-1,-1,-1,-1)
dim b(35)
dim pos0
dim s:s=Array("W+Enter: up   Z+Enter: down  A+Enter: left   S+Enter right ",_
              "Bad move!!                                                 ",_
	      "You did it! Another game? [y/n]+Enter                      ",_
	      "Bye!                                                       ")


do
  shuffle
  draw
  toxy 10,1,s(0)
  do
   if usr(wait()) then
     draw
     toxy 10,1,s(0)
   else 	
     toxy 10,1,s(1)
   end if
  loop until checkend
  toxy 10,1,s(2)
loop until wait()="n"
toxy 10,1,s(3)

function wait():
 toxy 11,1,"":
 wait=left(lcase(wscript.stdin.readline),1):	
end function

sub toxy(x,y,s)
 wscript.StdOut.Write ans0 & x & ";" & y & "H"& " "& s
end sub

sub draw
  dim i,j
  wscript.stdout.write anscls
  for i=0 to 3 'row
    for j=0 to 3  'col
      toxy (j*2)+2,(i*3)+3,iif(b(j*6+i+7)<>0,b(j*6+i+7)," ")
    next
  next
  toxy 10,1,""
end sub


function checkend
  dim i
  for i=0 to ubound(a)
   if (b(i)<>a(i)) then checkend=false : exit function
  next
  checkend=true
end function	

function move(d)
 dim p1
 p1=pos0+d
 if b(p1) <>-1 then
    b(pos0)=b(p1):
    b(p1)=0:
    pos0=p1:
    move=true
 else
   move=false
 end if
end function

sub shuffle
  dim cnt,r,i
   randomize timer
   for i=0 to ubound(a):b(i)=a(i):next
   pos0=28
   cnt=0
   do
     r=int(rnd*4)
     if move(dirs(r))=true then cnt=cnt+1
   loop until cnt=maxshuffle
end sub	

function iif(a,b,c): if a then iif=b else iif=c end if:end function			

function usr(a)
  dim d
  select case lcase(a)
  case "w" :d=-6
  case "z" :d=6
  case "a" :d=-1
  case "s" :d=1
  end select
  usr= move(d)
end function	
