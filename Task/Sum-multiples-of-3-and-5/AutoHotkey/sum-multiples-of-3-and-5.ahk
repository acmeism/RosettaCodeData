n := 1000

msgbox % "Sum is " . Sum3_5(n)   . " for n = " . n
msgbox % "Sum is " . Sum3_5_b(n) . " for n = " . n

;Standard simple Implementation.
Sum3_5(n) {
	sum := 0
	loop % n-1 {
		if (!Mod(a_index,3) || !Mod(a_index,5))
		sum:=sum+A_index
	}
	return sum
}

;Translated from the C++ version.
Sum3_5_b( i ) {
	sum := 0, a := 0
	while (a < 28)
	{
		if (!Mod(a,3) || !Mod(a,5))
		{
			sum += a
			s := 30
			while (s < i)
			{
				if (a+s < i)
					sum += (a+s)
				s+=30
			}
		}
		a+=1
	}
	return sum
}
