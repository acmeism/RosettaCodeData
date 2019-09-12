3.14           ! basic float
+3.14          ! Optional signs
-3.14
10e5           ! exponents signified by e or E
10E+5          ! with optional signs
+10e-5
1.             ! equivalent to 1.0
.5             ! equivalent to 0.5
1/2.           ! floating point approximation of a ratio (0.5)
1/3.           ! 0.3333333333333333
1/0.           ! positive infinity
-1/0.          ! negative infinity
0/0.           ! not-a-number
               ! hexadecimal, octal, and binary float literals are supported.
               ! they require a base 2 exponent expressed as a decimal
               ! preceded by p or P.
0x1.0p3        ! 8.0
-0x1.0P-3      ! -0.125
0b1.010001p3   ! 10.125
0o1.21p3       ! 10.125
               ! comma separators are allowed
1,234.123,456  ! 1234.123456


! normalized hex form ±0x1.MMMMMMMMMMMMMp±EEEE allows any floating-point
! number to be specified precisely according to IEEE 754 representation
+0x1.1234567891234p+0002   ! 4.28444444440952
