'#include "isprime.bas"

Const As Double Euler = 0.57721566490153286

Dim As Double m = 0
For x As Ulongint = 2 To 1e8
    If isPrime(x) Then m += Log(1-(1/x)) + (1/x)
Next x
Print "MM ="; Euler + m
Sleep
