result := "First 30 Jacobsthal numbers:`n"
loop 30
    result .= Jacobsthal(A_Index-1) (mod(A_Index, 5) ? " ":"`n")

result .= "`nFirst 30 Jacobsthal-Lucas numbers:`n"
loop 30
    result .= Jacobsthal_Lucas(A_Index-1) (mod(A_Index, 5) ? " ":"`n")

result .= "`nFirst 20 Jacobsthal oblong numbers:`n"
loop 20
    result .= SubStr("        " Jacobsthal(A_Index-1) * Jacobsthal(A_Index), -8) (mod(A_Index, 5) ? " ":"`n")

result .= "`nFirst 10 Jacobsthal primes:`n"
c:=0
while c < 10
    if (prime_numbers(x:=Jacobsthal(A_Index)).Count() = 1 && x > 1)
        result .= x (mod(++c, 5) ? " ":"`n")

MsgBox, 262144, , % result
return
