con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main | n
  ser.start(31, 30, 0, 115200)

  n := 1024
  repeat while n > 0
    ser.dec(n)
    ser.tx(32)
    n /= 2

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)
