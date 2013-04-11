/*REXX program writes  two arrays  to a file  with  limited precision.  */
outfid='OUTPUT.TXT'                /*this is operating system dependent.*/
x.=''                      ;   y.=''
x.1=1                      ;   y.1=1
x.2=2                      ;   y.2=1.4142135623730951
x.3=3                      ;   y.3=1.7320508075688772
x.4=1e11                   ;   y.4=316227.76601683791

xprecision = 3
yprecision = 5
padding=left('',4)                     /*number of blanks between cols. */
                     do j=1 while x.j\==''
                     x.j=funnyway(x.j,xprecision)
                     y.j=funnyway(y.j,yprecision)
                     aLine=translate(x.j || padding || y.j,'e',"E")
                     say aLine
                     call lineout outfid,aLine
                     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FUNNYWAY subroutine─────────────────*/
funnyway:  procedure;  parse arg a,p;   numeric digits p;   a=format(a,,p)
parse var a i 'E' e                    /*format # according to the rules*/
parse var i i '.' f
f=strip(f,'Trailing',0)
if f\==''  then f='.'f
if e\==''  then e='E'e
a=i || f || e
if datatype(a,'W')  then return format(arg(1)/1,,0)     /*whole number? */
                         return format(arg(1)/1,,,3,0)  /*use 3 dec digs*/
