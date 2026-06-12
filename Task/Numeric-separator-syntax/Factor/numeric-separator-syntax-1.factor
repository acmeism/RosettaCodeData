USE: prettyprint

12,345 .   ! 12345

! commas may be used at arbitrary intervals
1,23,456,78910 .  ! 12345678910

! a comma at the beginning or end will parse as a word, likely causing an error
! ,123 .   ! No word named “,123” found in current vocabulary search path
! 123, .   ! No word named “123,” found in current vocabulary search path

! likewise, two commas in a row will parse as a word
! 1,,23 .   ! No word named “1,,23” found in current vocabulary search path

! There are no exceptions to which numbers may have separators
! binary/octal/decimal/hexadecimal integers and floats are supported
0b1,000,001 .   ! 65
-1,234e-4,5 .   ! -1.234e-42
0x1.4,4p3 .   ! 10.125

! as are ratios
45,2+1,1/43,2 .   ! 452+11/432
1,1/1,7 .   ! 11/17

! and complex numbers
C{ 5.225,312 2.0 } .   ! C{ 5.225312 2.0 }
