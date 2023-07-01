con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main | i
  ser.start(31, 30, 0, 115200)

  repeat i from 1 to 10
    ser.dec(i)
    if i // 5
      ser.str(string(", "))
      next
    ser.str(string(13,10))

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)
