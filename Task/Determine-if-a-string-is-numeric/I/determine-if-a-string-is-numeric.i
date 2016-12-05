function numeric(""n) {
	number(n)
	issues {
		print(n, "  is not numeric!")
		return
	}
	print(n, "  is numeric :)")
}

software {
	numeric("1200")
	numeric("3.14")
	numeric("3/4")
	numeric("abcdefg")
}
