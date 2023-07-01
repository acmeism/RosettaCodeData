; 1. Create a function/subroutine/method that given p generates the coefficients of the expanded polynomial representation of (x-1)^p.
; Function modified from http://rosettacode.org/wiki/Pascal%27s_triangle#AutoHotkey
pascalstriangle(n=8) ; n rows of Pascal's triangle
{
	p := Object(), z:=Object()
	Loop, % n
		Loop, % row := A_Index
			col := A_Index
			, p[row, col] := row = 1 and col = 1
				? 1
				: (p[row-1, col-1] = "" ; math operations on blanks return blanks; I want to assume zero
					? 0
					: p[row-1, col-1])
				- (p[row-1, col] = ""
					? 0
					: p[row-1, col])
	Return p
}

; 2. Use the function to show here the polynomial expansions of p for p in the range 0 to at least 7, inclusive.
For k, v in pascalstriangle()
{
	s .= "`n(x-1)^" k-1 . "="
	For k, w in v
		s .= "+" w "x^" k-1
}
s := RegExReplace(s, "\+-", "-")
s := RegExReplace(s, "x\^0", "")
s := RegExReplace(s, "x\^1", "x")
Msgbox % clipboard := s

; 3. Use the previous function in creating another function that when given p returns whether p is prime using the AKS test.
aks(n)
{
	isnotprime := False
	For k, v in pascalstriangle(n+1)[n+1]
		(k != 1 and k != n+1) ? isnotprime |= !(v // n = v / n) ; if any is not divisible, returns true
	Return !isnotprime
}

; 4. Use your AKS test to generate a list of all primes under 35.
i := 49
p := pascalstriangle(i+1)
Loop, % i
{
	n := A_Index
	isnotprime := False
	For k, v in p[n+1]
		(k != 1 and k != n+1) ? isnotprime |= !(v // n = v / n) ; if any is not divisible, returns true
	t .= isnotprime ? "" : A_Index " "
}
Msgbox % t
Return
