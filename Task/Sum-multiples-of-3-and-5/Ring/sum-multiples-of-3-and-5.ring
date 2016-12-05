see sum35(1000) + nl

func sum35 n
     n = n - 1
     return(3 * tri(floor(n / 3)) +
	    5 * tri(floor(n / 5)) -
	    15 * tri(floor(n / 15)))

func tri n
     return n * (n + 1) / 2
