con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main | n
  ser.start(31, 30, 0, 115200)

  repeat n from 1 to 10
    ser.dec(n)
    if n<10
      ser.str(string(", "))
  ser.str(string(13, 10))

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)
