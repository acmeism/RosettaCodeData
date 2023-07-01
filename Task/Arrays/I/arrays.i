main
	//Fixed-length arrays.
	f $= array.integer[1]()
	f[0] $= 2
	print(f[0])

	//Dynamic arrays.
	d $= list.integer()
	d[+] $= 2
	print(d[1])
}
