' ============================================
' https://rosettacode.org/wiki/Temperature_conversion
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' Constants hold the fixed physical values.
' The input temperature is a variable.
' ============================================

[inits]
    LET ABS_ZERO#  = 273.15   ' Kelvin → Celsius offset (absolute zero in °C)
    LET F_SCALE#   = 1.8      ' Fahrenheit / Rankine scale factor
    LET F_OFFSET#  = 459.67   ' Fahrenheit offset from absolute zero

[main-input]
    INPUT "Kelvin degrees (>=0): ", k$ ' INPUT auto-declares var. itself

[conversions]
    PRINT "K = "; k$
    PRINT "C = "; k$ - ABS_ZERO#
    PRINT "F = "; k$ * F_SCALE# - F_OFFSET#
    PRINT "R = "; k$ * F_SCALE#
END

' Output:
' Kelvin degrees (>=0): 99
' K = 99
' C = -174.14999999999998
' F = -281.47
' R = 178.20000000000002
