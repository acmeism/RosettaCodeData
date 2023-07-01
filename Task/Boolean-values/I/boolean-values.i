main
	//Bits aka Booleans.
	b $= bit()

	b $= true
	print(b)

	b $= false
	print(b)
	
	//Non-zero values are true.
	b $= bit(1)
	print(b)

	b $= -1
	print(b)

	//Zero values are false
	b $= 0
	print(b)
}
