con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main | i
  ser.start(31, 30, 0, 115200)

  repeat i from 0 to 10
    ser.dec(fac(i))
    ser.tx(32)

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)

pub fac(n) : f
  f := 1
  repeat while n > 0
    f *= n
    n -= 1
