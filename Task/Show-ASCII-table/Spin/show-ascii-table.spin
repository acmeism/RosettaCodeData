con
  _clkmode = xtal1+pll16x
  _clkfreq = 80_000_000

obj
  ser : "FullDuplexSerial"

pub main | i, j

  ser.start(31, 30, 0, 115200)

  repeat i from 0 to 15
    repeat j from i + 32 to 127 step 16
      if j < 100
        ser.tx(32)
      ser.dec(j)
      ser.str(string(": "))
      case j
        32:
          ser.str(string("SPC"))
        127:
          ser.str(string("DEL"))
        other:
          ser.tx(j)
          ser.str(string("  "))
      ser.str(string("  "))
    ser.str(string(13, 10))

  waitcnt(_clkfreq + cnt)
  ser.stop
