con
  _clkmode = xtal1+pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial"

pub main | d, n

  ser.start(31, 30, 0, 115200)

  repeat n from 2 to 100

    repeat d from 2 to n-1
      if n // d == 0
        quit

    if d == n
      ser.dec(n)
      ser.tx(32)

  waitcnt(_clkfreq + cnt)
  ser.stop
