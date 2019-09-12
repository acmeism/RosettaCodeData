con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main | n
  ser.start(31, 30, 0, 115200)

  n := 0
  repeat
    n += 1
    ser.dec(n)
    ser.tx(32)
  while n // 6

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)
