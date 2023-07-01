> sprintf("%f", pi)
[1] "3.141593"
> sprintf("%.3f", pi)
[1] "3.142"
> sprintf("%1.0f", pi)
[1] "3"
> sprintf("%5.1f", pi)
[1] "  3.1"
> sprintf("%05.1f", pi)
[1] "003.1"
> sprintf("%+f", pi)
[1] "+3.141593"
> sprintf("% f", pi)
[1] " 3.141593"
> sprintf("%-10f", pi)# left justified
[1] "3.141593  "
> sprintf("%e", pi)
[1] "3.141593e+00"
> sprintf("%E", pi)
[1] "3.141593E+00"
> sprintf("%g", pi)
[1] "3.14159"
> sprintf("%g",   1e6 * pi) # -> exponential
[1] "3.14159e+06"
> sprintf("%.9g", 1e6 * pi) # -> "fixed"
[1] "3141592.65"
> sprintf("%G", 1e-6 * pi)
[1] "3.14159E-06"
