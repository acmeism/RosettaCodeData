'ANSI Clock

'ansi escape functions
ans0=chr(27)&"["
sub cls()  wscript.StdOut.Write ans0 &"2J"&ans0 &"?25l":end sub
sub torc(r,c,s)  wscript.StdOut.Write ans0 & r & ";" & c & "f"  & s :end sub

'bresenham
Sub draw_line(r1,c1, r2,c2,c)
  Dim x,y,xf,yf,dx,dy,sx,sy,err,err2
  x =r1    : y =c1
  xf=r2    : yf=c2
  dx=Abs(xf-x) : dy=Abs(yf-y)
  If x<xf Then sx=+1: Else sx=-1
  If y<yf Then sy=+1: Else sy=-1
  err=dx-dy
  Do
    torc x,y,c
    If x=xf And y=yf Then Exit Do
    err2=err+err
    If err2>-dy Then err=err-dy: x=x+sx
    If err2< dx Then err=err+dx: y=y+sy
  Loop
End Sub

const pi180=0.017453292519943
'center of the clock
const r0=13
const c0=26

'angles
nangi=-30*pi180
aangi=-6*pi180
ang0=90*pi180

'lengths of hands
lh=7
lm=9
ls=9
ln=12


while 1
     cls

    'dial
    angn=ang0+nangi
    for i=1 to 12
      torc r0-cint(ln*sin(angn)),cint(c0+2*ln*cos(angn)),i
      angn=angn+nangi
    next

    'get time and display it in numbers
    t=now()
    torc 1,1, hour(t) &":"& minute(t) &":"& second(t)

    'angle for each hand
    angh=ang0+hour(t) *nangi
    angm=ang0+minute(t) *aangi
    angS=ang0+second(t) *aangi

    'draw them
    draw_line r0,c0,cint(r0-ls*sin(angs)),cint(c0+2*ls*cos(angs)),"."
    draw_line r0,c0,cint(r0-lm*sin(angm)),cint(c0+2*lm*cos(angm)),"*"
    draw_line r0,c0,cint(r0-lh*sin(angh)),cint(c0+2*lh*cos(angh)),"W"
    torc r0,c0,"O"

    'wait one second
    wscript.sleep(1000)
wend
