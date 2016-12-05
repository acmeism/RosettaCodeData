shared void ninetyNineBottles() {
	
	String bottles(Integer count) =>
			"``count == 0 then "No" else count``
			 bottle``count == 1 then "" else "s"``".normalized;
	
	for(i in 99..1) {
		print("``bottles(i)`` of beer on the wall
		       ``bottles(i)`` of beer!
		       Take one down, pass it around
		       ``bottles(i - 1)`` of beer on the wall!\n");
	}
}
