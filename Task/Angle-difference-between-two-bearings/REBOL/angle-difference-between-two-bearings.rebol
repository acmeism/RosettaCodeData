Rebol [
    title: "Rosetta code: Angle difference between two bearings"
    file:  %Angle_difference_between_two_bearings.r3
    url:   https://rosettacode.org/wiki/Angle_difference_between_two_bearings
]

angle-diff: function [
    "Returns shortest signed angular difference from b1 to b2 in degrees, range (-180, 180]."
    b1 [integer! decimal!]
    b2 [integer! decimal!]
][
    angle: b2 - b1 % 360
    case [
        angle < -180 [ angle: angle + 360 ]
        angle >= 180 [ angle: angle - 360 ]
    ]
    angle
]

foreach [b1 b2] [
     20.00      45.00 ;=   25.00
    -45.00      45.00 ;=   90.00
    -85.00      90.00 ;=  175.00
    -95.00      90.00 ;= -175.00
    -45.00     125.00 ;=  170.00
    -45.00     145.00 ;= -170.00
     29.48     -88.64 ;= -118.12
    -78.33    -159.04 ;=  -80.71
 -70099.74   29840.67 ;= -139.58
-165313.67   33693.99 ;=  -72.34
   1174.84 -154146.66 ;= -161.50
  60175.77   42213.07 ;=   37.30
][
    printf ["b1: " 12 " b2: " 12 "angle diff b2 - b1 = " /green -6.1 /reset][
        b1 b2 angle-diff b1 b2
    ]
]
