/* REXX ---------------------------------------------------------------
* 25.06.2014 Walter Pachl
*--------------------------------------------------------------------*/
times='23:00:17 23:40:20 00:12:45 00:17:19'
sum=0
day=86400
x=0
y=0
Do i=1 To words(times)                 /* loop over times            */
  time.i=word(times,i)                 /* pick a time                */
  alpha.i=t2a(time.i)                  /* convert to angle (degrees) */
  /* Say time.i format(alpha.i,6,9) */
  x=x+rxcalcsin(alpha.i)               /* accumulate sines           */
  y=y+rxcalccos(alpha.i)               /* accumulate cosines         */
  End
ww=rxcalcarctan(x/y)                   /* compute average angle      */
ss=ww*86400/360                        /* convert to seconds         */
If ss<0 Then ss=ss+day                 /* avoid negative value       */
m=ss%60                                /* split into hh mm ss        */
s=ss-m*60
h=m%60
m=m-h*60
Say f2(h)':'f2(m)':'f2(s)              /* show the mean time         */
Exit

t2a: Procedure Expose day              /* convert time to angle      */
  Parse Arg hh ':' mm ':' ss
  sec=(hh*60+mm)*60+ss
  If sec>(day/2) Then
    sec=sec-day
  a=360*sec/day
  Return a

f2: return right(format(arg(1),2,0),2,0)

::requires rxmath library
