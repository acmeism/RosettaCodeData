Parse Version v
Say 'Version='v
Call time 'R'
Do a=0 To 100
  Do b=0 To 100
    Do c=0 To 100
      x1.a.b.c=lcm1(a,b,c)
      End
    End
  End
Say 'version 1' time('E')
Call time 'R'
Do a=0 To 100
  Do b=0 To 100
    Do c=0 To 100
      x2.a.b.c=lcm2(a,b,c)
      End
    End
  End
Say 'version 2' time('E')
cnt.=0
Do a=0 To 100
  Do b=0 To 100
    Do c=0 To 100
      If x1.a.b.c=x2.a.b.c then cnt.0ok=cnt.0ok+1
      End
    End
  End
Say cnt.0ok 'comparisons ok'
Exit
/*----------------------------------LCM subroutine----------------------*/
lcm1: procedure; d=strip(arg(1) arg(2));  do i=3  to arg(); d=d arg(i); end
parse var d x d                        /*obtain the first value in args.*/
x=abs(x)                               /*use the absolute value of  X.  */
          do  while d\==''             /*process the rest of the args.  */
          parse var d ! d;   !=abs(!)  /*pick off the next arg (ABS val)*/
          if !==0  then return 0       /*if zero, then LCM is also zero.*/
          x=x*!/gcd1(x,!)               /*have  GCD do the heavy lifting.*/
          end   /*while*/
return x                               /*return with  LCM  of arguments.*/
/*----------------------------------GCD subroutine----------------------*/
gcd1: procedure; d=strip(arg(1) arg(2));  do j=3  to arg(); d=d arg(j); end
parse var d x d                        /*obtain the first value in args.*/
x=abs(x)                               /*use the absolute value of  X.  */
          do  while d\==''             /*process the rest of the args.  */
          parse var d y d;   y=abs(y)  /*pick off the next arg (ABS val)*/
          if y==0  then iterate        /*if zero, then ignore the value.*/
               do  until y==0;  parse  value   x//y  y   with  y  x;   end
          end   /*while*/
return x                               /*return with  GCD  of arguments.*/

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
