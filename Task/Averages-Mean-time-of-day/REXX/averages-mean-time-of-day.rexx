/* REXX ---------------------------------------------------------------
* 25.06.2014 Walter Pachl
* taken from ooRexx using my very aged sin/cos/artan functions
*--------------------------------------------------------------------*/
times='23:00:17 23:40:20 00:12:45 00:17:19'
sum=0
day=86400
pi=3.14159265358979323846264
x=0
y=0
Do i=1 To words(times)                 /* loop over times            */
  time.i=word(times,i)                 /* pick a time                */
  alpha.i=t2a(time.i)                  /* convert to angle (radians) */
  /* Say time.i format(alpha.i,6,9) */
  x=x+sin(alpha.i)                     /* accumulate sines           */
  y=y+cos(alpha.i)                     /* accumulate cosines         */
  End
ww=arctan(x/y)                         /* compute average angle      */
ss=ww*86400/(2*pi)                     /* convert to seconds         */
If ss<0 Then ss=ss+day                 /* avoid negative value       */
m=ss%60                                /* split into hh mm ss        */
s=ss-m*60
h=m%60
m=m-h*60
Say f2(h)':'f2(m)':'f2(s)              /* show the mean time         */
Exit

t2a: Procedure Expose day pi           /* convert time to angle      */
  Parse Arg hh ':' mm ':' ss
  sec=(hh*60+mm)*60+ss
  If sec>(day/2) Then
    sec=sec-day
  a=2*pi*sec/day
  Return a

f2: return right(format(arg(1),2,0),2,0)


sin: Procedure Expose pi
  Parse Arg x
  prec=digits()
  Numeric Digits (2*prec)
  Do While x>pi
    x=x-pi
    End
  Do While x<-pi
    x=x+pi
    End
  o=x
  u=1
  r=x
  Do i=3 By 2
    ra=r
    o=-o*x*x
    u=u*i*(i-1)
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits prec
  Return r+0

cos: Procedure Expose pi
  Parse Arg x
  prec=digits()
  Numeric Digits (2*prec)
  Numeric Fuzz 3
  o=1
  u=1
  r=1
  Do i=1 By 2
    ra=r
    o=-o*x*x
    u=u*i*(i+1)
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits prec
  Return r+0

arctan: Procedure
  Parse Arg x
  prec=digits()
  Numeric Digits (2*prec)
  Numeric Fuzz 3
  o=x
  u=1
  r=x
  k=0
  Do i=3 By 2
    ra=r
    o=-o*x*x
    r=r+(o/i)
    If r=ra Then
      Leave
    k=k+1
    If k//1000=0 Then
      Say i left(r,40) format(abs(o/i),15,5)
    End
  Numeric Digits (prec)
  Return r+0
