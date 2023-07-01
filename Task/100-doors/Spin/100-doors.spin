con
  _clkmode = xtal1+pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub init
  ser.start(31, 30, 0, 115200)

  doors

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)

var

  byte door[101] ' waste one byte by using only door[1..100]

pri doors | i,j

  repeat i from 1 to 100
    repeat j from i to 100 step i
      not door[j]

  ser.str(string("Open doors: "))

  repeat i from 1 to 100
    if door[i]
      ser.dec(i)
      ser.tx(32)

  ser.str(string(13,10))
