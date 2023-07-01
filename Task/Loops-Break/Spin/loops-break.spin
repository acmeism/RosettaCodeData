con
  _clkmode = xtal1 + pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial.spin"

pub main | r, s
  ser.start(31, 30, 0, 115200)

  s := 1337 ' PRNG seed

  repeat
    r := ||?s // 20
    ser.dec(r)
    ser.tx(32)
    if r == 10
      quit
    r := ||?s // 20
    ser.dec(r)
    ser.tx(32)

  waitcnt(_clkfreq + cnt)
  ser.stop
  cogstop(0)
