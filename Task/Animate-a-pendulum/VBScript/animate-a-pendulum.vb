option explicit

 const dt = 0.15
 const length=23
 dim ans0:ans0=chr(27)&"["
 dim Veloc,Accel,angle,olr,olc,r,c
const r0=1
const c0=40
 cls
 angle=0.7
 while 1
    wscript.sleep(50)
    Accel = -.9 * sin(Angle)
    Veloc = Veloc + Accel * dt
    Angle = Angle + Veloc * dt

    r = r0 + int(cos(Angle) * Length)
    c = c0+ int(2*sin(Angle) * Length)
    cls
    draw_line r,c,r0,c0
    toxy r,c,"O"

    olr=r :olc=c
wend

sub cls()  wscript.StdOut.Write ans0 &"2J"&ans0 &"?25l":end sub
sub toxy(r,c,s)  wscript.StdOut.Write ans0 & r & ";" & c & "f"  & s :end sub

Sub draw_line(r1,c1, r2,c2)  'Bresenham's line drawing
  Dim x,y,xf,yf,dx,dy,sx,sy,err,err2
  x =r1    : y =c1
  xf=r2    : yf=c2
  dx=Abs(xf-x) : dy=Abs(yf-y)
  If x<xf Then sx=+1: Else sx=-1
  If y<yf Then sy=+1: Else sy=-1
  err=dx-dy
  Do
    toxy x,y,"."
    If x=xf And y=yf Then Exit Do
    err2=err+err
    If err2>-dy Then err=err-dy: x=x+sx
    If err2< dx Then err=err+dx: y=y+sy
  Loop
End Sub 'draw_line
