/*REXX program  "boxes the compass"                                    */
/*                   [from degree (º) headings  --->  a 32 point set]. */
Parse Arg degrees
If degrees='' Then
  degrees=0 16.87 16.88 33.75 50.62 50.63 67.5 84.37 84.38 101.25,
          118.12 118.13 135 151.87 151.88 168.75 185.62 185.63 202.5,
          219.37 219.38 236.25 253.12 253.13 270 286.87 286.88 303.75,
          320.62 320.63 337.5 354.37 354.38
names='n nbe n-ne nebn ne nebe e-ne ebn e ebs e-se sebe se sebs s-se sbe',
      's sbw s-sw swbs sw swbw w-sw wbs w wbn w-nw nwbw nw nwbn n-nw nbw'

nn=words(names)+1                 /* nn:  used for integer ÷ remainder */
dirs='north south east west'      /* define cardinal compass directions*/
/* choose a glyph for degree  (°).*/
If 4=='f4'x Then                     /* is this system an EBCDIC system*/
  degsym='a1'x
Else
  degsym='f8'x                       /* or degsym='a7'x                */
Say right(degsym'heading',30) center('compass heading',20)
Say right('--------',30) copies('-',20)
pad=' '                           /* used to interject a blank for o   */
Do i=1 To words(degrees)
  x=word(degrees,i)               /* obtain one of the degree headings */
  Say right(format(x,,2)degsym,30-1) pad boxheading(x)
  End
Exit                              /* stick a fork in it, we're all done*/
/*---------------------------------------------------------------------*/
boxheading:
  y=arg(1)//360
  If y<0 Then
    y=360-y                    /* normalize heading within unit circle */
  z=word(names,trunc(max(1,(y/11.25+1.5)//nn))) /* degrees->heading    */
  /* n e s w are now replaced by north east south west, respectively   */
  Do k=1 To words(dirs)
    d=word(dirs,k)
    z=changestr(left(d,1),z,d)
    End
  Return changestr('b',z,' by ')     /* expand  'b' ---? ' by '.       */
