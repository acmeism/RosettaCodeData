lcm2: procedure
x=abs(arg(1))
do k=2 to arg() While x<>0
  y=abs(arg(k))
  x=x*y/gcd2(x,y)
  end
return x

gcd2: procedure
x=abs(arg(1))
do j=2 to arg()
  y=abs(arg(j))
  If y<>0 Then Do
    do until z==0
      z=x//y
      x=y
      y=z
      end
    end
  end
return x
