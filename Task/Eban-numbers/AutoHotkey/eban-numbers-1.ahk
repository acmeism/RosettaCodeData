eban_numbers(min, max, show:=0){
	counter := 0, output := ""
	i := min
	while ((i+=2) <= max)
	{
		b := floor(i / 1000000000)
		r := Mod(i, 1000000000)
		m := floor(r / 1000000)
		r := Mod(i, 1000000)
		t := floor(r / 1000)
		r := Mod(r, 1000)		
		if (m >= 30 && m <= 66)
			m := Mod(m, 10)
		if (t >= 30 && t <= 66)
			t := Mod(t, 10)
		if (r >= 30 && r <= 66)
			r := Mod(r, 10)
		if (b = 0 || b = 2 || b = 4 || b = 6)
		&& (m = 0 || m = 2 || m = 4 || m = 6)
		&& (t = 0 || t = 2 || t = 4 || t = 6)
		&& (r = 0 || r = 2 || r = 4 || r = 6)
			counter++, (show ? output .= i " " : "")
	}
	return min "-" max " : " output " Count = " counter
}
