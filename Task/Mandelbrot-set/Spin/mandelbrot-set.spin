con
  _clkmode = xtal1+pll16x
  _clkfreq = 80_000_000

  xmin=-8601    ' int(-2.1*4096)
  xmax=2867     ' int( 0.7*4096)

  ymin=-4915    ' int(-1.2*4096)
  ymax=4915     ' int( 1.2*4096)

  maxiter=25

obj
  ser : "FullDuplexSerial"

pub main | c,cx,cy,dx,dy,x,y,x2,y2,iter

  ser.start(31, 30, 0, 115200)

  dx:=(xmax-xmin)/79
  dy:=(ymax-ymin)/24

  cy:=ymin
  repeat while cy=<ymax
    cx:=xmin
    repeat while cx=<xmax
      x:=0
      y:=0
      x2:=0
      y2:=0
      iter:=0
      repeat while iter=<maxiter and x2+y2=<16384
        y:=((x*y)~>11)+cy
        x:=x2-y2+cx
        iter+=1
        x2:=(x*x)~>12
        y2:=(y*y)~>12
      cx+=dx
      ser.tx(iter+32)
    cy+=dy
    ser.str(string(13,10))

  waitcnt(_clkfreq+cnt)
  ser.stop
