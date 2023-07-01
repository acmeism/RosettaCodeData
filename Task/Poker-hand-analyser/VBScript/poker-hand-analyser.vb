option explicit
class playingcard
 dim suit
 dim pips
  'public property get gsuit():gsuit=suit:end property
  'public property get gpips():gpips=pips:end property
  public sub print
		dim s,p
		select case suit
		case "S":s=chrW(&h2660)
		case "D":s=chrW(&h2666)
		case "C":s=chrW(&h2663)
		case "H":s=chrW(&h2665)
		end select

		select case pips
		case 1:p="A"
		case 11:p="J"
		case 12:p="Q"
		case 13:p="K"
		case else: p=""& pips
		end select

		wscript.stdout.write  right("   "&p & s,3)&" "
  end sub
end class

sub printhand(byref h,start)
   dim i
   for i =start to ubound(h)
     h(i).print
   next
   'wscript.stdout.writeblanklines(1)
end sub

function checkhand(byval arr)
  dim ss,i,max,last,uses,toppip,j,straight, flush,used,ace
  redim nn(13)

  ss=arr(0).suit   '?????
  straight=true:flush=true
  max=0:last=0:used=0:toppip=0:ace=0
  for i=0 to ubound(arr)
      j=arr(i).pips
      if arr(i).suit<>ss then flush=false
      if j>toppip then toppip=j
      if j=1 then ace=1
      nn(j)=nn(j)+1
      if nn(j)>max then max= nn(j)
      if abs(j-toppip)>=4  then straight=0
   next
   for i=1 to ubound(nn)
      if nn(i) then used=used+1
   next
   if max=1 then
      if nn(1) and nn(10) and nn(11) and nn(12) and nn(13) then straight=1
   end if
   if flush and straight and max=1 then
      checkhand= "straight-flush"
   elseif flush then
      checkhand= "flush"
   elseif straight and max=1 then
      checkhand= "straight"
   elseif max=4 then
     checkhand= "four-of-a-kind"
   elseif max=3 then
     if used=2 then
       checkhand= "full-house"
     else
       checkhand= "three-of-a-kind"
     end if
  elseif max=2 then
     if used=3 then
       checkhand= "two-pair"
     else
       checkhand= "one-pair"
     end if
  else
     checkhand= "Top "& toppip
  End If
end function


function readhand(h)
  dim i,b,c,p
  redim a(4)
  for i=0 to ubound(a)
    b=h(i)
    set c=new playingcard
    p=left(b,1)
    select case p
    case "j": c.pips=11
    case "q": c.pips=12
    case "k": c.pips=13
    case "t": c.pips=10
    case "a": c.pips=1
    case else c.pips=cint(p)
    end select
    c.suit=ucase(right(b,1))
    set a(i)=c
  next
  readhand=a
  erase a
end function

dim hands,hh,i
 hands = Array(_
Array("2h", "5h", "7d", "8c", "9s"),_
Array("2h", "2d", "2c", "kc", "qd"),_
Array("ah", "2d", "3c", "4c", "5d"),_
Array("2h", "3h", "2d", "3c", "3d"),_
Array("2h", "7h", "2d", "3c", "3d"),_
Array("th", "jh", "qh", "kh", "ah"),_
Array("4h", "4s", "ks", "5d", "ts"),_
Array("qc", "tc", "7c", "6c", "4c"),_
Array("ah", "ah", "7c", "6c", "4c"))

for i=1 to ubound(hands)
   hh=readhand(hands(i))
   printhand hh,0
   wscript.stdout.write vbtab & checkhand(hh)
   wscript.stdout.writeblanklines(1)
   'exit for
next
