con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main
  ser.start(31, 30, 0, 115200)

  repeat
    ser.str(string("SPAM",13,10))

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)
