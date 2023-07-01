//Strings are immutable in 'i'.
software {
	a = "Hello World"
	b = a //This copies the string.
	
	a += "s"
	
	print(a)
	print(b)
}
