# Project : Angle difference between two bearings

decimals(4)
see "Input in -180 to +180 range:" + nl
see getDifference(20.0, 45.0) + nl
see getDifference(-45.0, 45.0) + nl
see getDifference(-85.0, 90.0) + nl
see getDifference(-95.0, 90.0) + nl
see getDifference(-45.0, 125.0) + nl
see getDifference(-45.0, 145.0) + nl
see getDifference(-45.0, 125.0) + nl
see getDifference(-45.0, 145.0) + nl
see getDifference(29.4803, -88.6381) + nl
see getDifference(-78.3251, -159.036) + nl

func getDifference(b1, b2)
     r = (b2 - b1) % 360.0
     if r >= 180.0
        r = r - 360.0
     end
     return r
