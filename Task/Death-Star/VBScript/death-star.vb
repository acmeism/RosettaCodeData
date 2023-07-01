'deathstar ascii graphics

option explicit

const x_=0
const y_=1
const z_=2
const r_=3

function clamp(x,b,t)
  if x<b then
     clamp=b
  elseif x>t then
    clamp =t
  else
    clamp=x
  end if
end function

function dot(v,w) dot=v(x_)*w(x_)+v(y_)*w(y_)+v(z_)*w(z_): end function

function normal (byval v)
    dim ilen:ilen=1/sqr(dot(v,v)):
    v(x_)=v(x_)*ilen: v(y_)=v(y_)*ilen: v(z_)=v(z_)*ilen:
    normal=v:
end function

function hittest(s,x,y)
   dim z
   z = s(r_)^2 - (x-s(x_))^2 - (y-s(y_))^2
   if z>=0  then
     z=sqr(z)
     hittest=array(s(z_)-z,s(z_)+z)
   else
     hittest=0
  end if
end function

sub deathstar(pos, neg, sun, k, amb)
  dim x,y,shades,result,shade,hp,hn,xx,b
  shades=array(" ",".",":","!","*","o","e","&","#","%","@")
  for y = pos(y_)-pos(r_)-0.5 to pos(y_)+pos(r_)+0.5
    for x = pos(x_)-pos(r_)-0.5 to pos(x_)+pos(r_)+.5
      hp=hittest (pos, x, y)
      hn=hittest(neg,x,y)
      if not  isarray(hp) then
         result=0
      elseif not isarray(hn) then
        result=1
      elseif hn(0)>hp(0)  then
        result=1
      elseif  hn(1)>hp(1) then
        result=0
      elseif hn(1)>hp(0) then
        result=2
      else
        result=1
      end if

      shade=-1
      select case result
      case 0
        shade=0
      case 1
        xx=normal(array(x-pos(x_),y-pos(y_),hp(0)-pos(z_)))
        'shade=clamp(1-dot(sun,xx)^k+amb,1,ubound(shades))
      case 2
        xx=normal(array(neg(x_)-x,neg(y_)-y,neg(z_)-hn(1)))
        'shade=clamp(1-dot(sun,xx)^k+amb,1,ubound(shades))
      end select
      if shade <>0 then
        b=dot(sun,xx)^k+amb
        shade=clamp((1-b) *ubound(shades),1,ubound(shades))
      end if
      wscript.stdout.write string(2,shades(shade))
    next
    wscript.stdout.write vbcrlf
  next
end sub

deathstar array(20, 20, 0, 20),array(10,10,-15,10), normal(array(-2,1,3)), 2, 0.1
