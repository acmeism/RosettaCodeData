x 0 = ""
x n = (x$n-1)++" +"++(y$n-1)++" f +"
y 0 = ""
y n = " - f"++(x$n-1)++" -"++(y$n-1)

dragon n =
	concat ["0 setlinewidth 300 400 moveto",
		"/f{2 0 rlineto}def/+{90 rotate}def/-{-90 rotate}def\n",
		"f", x n, " stroke showpage"]

main = putStrLn $ dragon 14
