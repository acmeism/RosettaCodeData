global cptext := a_tab "Nr" a_tab "Phi" a_tab "Prime?`n---------------------------------------------`n"

divisores(num)
{
	serie := ""
	loop % num
		if !mod(num,a_index)
			serie .= a_index ","
	return serie
}

gcd(serieA,serieB)
{
	emComum := 0
	loop,parse,serieA,csv
		if A_LoopField in %serieB%
			emComum += 1
	return emComum
}	
		
principal(voltas,phi:=0)
{
loop %voltas%
{
cp := A_Index
cpcount := 0
numA := divisores(cp)
loop % a_index
	{
		numA := divisores(cp)
		numB := divisores(A_Index)
		fim := gcd(numA,numB)
		if (fim = 1)
			cpcount += 1
	}		
if (cpcount = cp-1)
	{
		if phi
			cptext .= a_tab cp a_tab cpcount a_tab "1`n"
		totalPrimes += 1
	}
else
	cptext .= a_tab cp a_tab cpcount a_tab "0`n"
}
return totalPrimes
}

totalPrimes := principal(25,1)
msgbox % cptext "`n`ntotal primes  =  " totalPrimes ; Number 1 is a prime number ? If yes, add 1 to totalPrimes
totalPrimes := principal(100)
msgbox % "total primes in 1 .. 100  =  " totalPrimes
totalPrimes := principal(1000)							; caution... pure gcd method
msgbox % "total primes in 1 .. 1000  =  " totalPrimes  ; takes 3 minutes or more
;totalPrimes := principal(10000)
;msgbox % "total primes in 1 .. 10000  =  " totalPrimes
ExitApp
