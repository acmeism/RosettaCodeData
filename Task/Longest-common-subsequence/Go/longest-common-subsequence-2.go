func lcs(a, b string) string {
	arunes := []rune(a)
	brunes := []rune(b)
	aLen := len(arunes)
	bLen := len(brunes)
	lengths := make([][]int, aLen+1)
	for i := 0; i <= aLen; i++ {
		lengths[i] = make([]int, bLen+1)
	}
	// row 0 and column 0 are initialized to 0 already

	for i := 0; i < aLen; i++ {
		for j := 0; j < bLen; j++ {
			if arunes[i] == brunes[j] {
				lengths[i+1][j+1] = lengths[i][j] + 1
			} else if lengths[i+1][j] > lengths[i][j+1] {
				lengths[i+1][j+1] = lengths[i+1][j]
			} else {
				lengths[i+1][j+1] = lengths[i][j+1]
			}
		}
	}

	// read the substring out from the matrix
	s := make([]rune, 0, lengths[aLen][bLen])
	for x, y := aLen, bLen; x != 0 && y != 0; {
		if lengths[x][y] == lengths[x-1][y] {
			x--
		} else if lengths[x][y] == lengths[x][y-1] {
			y--
		} else {
			s = append(s, arunes[x-1])
			x--
			y--
		}
	}
	// reverse string
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
	return string(s)
}
