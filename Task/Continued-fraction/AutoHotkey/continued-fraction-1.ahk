sqrt2_a(n) ; function definition is as simple as that
{
return n?2.0:1.0
}

sqrt2_b(n)
{
return 1.0
}

napier_a(n)
{
return n?n:2.0
}

napier_b(n)
{
return n>1.0?n-1.0:1.0
}

pi_a(n)
{
return n?6.0:3.0
}

pi_b(n)
{
return (2.0*n-1.0)**2.0 ; exponentiation operator
}

calc(f,expansions)
{
r:=0,i:=expansions
; A nasty trick: the names of the two coefficient functions are generated dynamically
; a dot surrounded by spaces means string concatenation
f_a:=f . "_a",f_b:=f . "_b"

while i>0 {
; You can see two dynamic function calls here
r:=%f_b%(i)/(%f_a%(i)+r)
i--
}

return %f_a%(0)+r
}

Msgbox, % "sqrt 2 = " . calc("sqrt2", 1000) . "`ne = " . calc("napier", 1000) . "`npi = " . calc("pi", 1000)
