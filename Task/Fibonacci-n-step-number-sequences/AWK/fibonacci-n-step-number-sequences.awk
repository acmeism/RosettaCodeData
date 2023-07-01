function sequence(values, howmany) {
	init_length = length(values)
	for (i=init_length + 1; i<=howmany; i++) {
	   values[i] = 0
           for (j=1; j<=init_length; j++) {
             values[i] += values[i-j]
	   }
        }
	result = ""
        for (i in values) {
          result = result values[i] " "
        }
	delete values
	return result
}

# print some sequences
END	{
		a[1] = 1; a[2] = 1
		print("fibonacci :\t",sequence(a, 10))

		a[1] = 1; a[2] = 1; a[3] = 2
		print("tribonacci :\t",sequence(a, 10))

		a[1] = 1 ; a[2] = 1 ; a[3] = 2 ; a[4] = 4
		print("tetrabonacci :\t",sequence(a, 10))

		a[1] = 2; a[2] = 1
		print("lucas :\t\t",sequence(a, 10))
	}
