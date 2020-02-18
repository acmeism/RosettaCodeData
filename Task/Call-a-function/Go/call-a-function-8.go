	fn := func(r rune) rune {
		if unicode.IsSpace(r) {
			return -1
		}
		return r
	}
	strings.Map(fn, "Spaces removed")
	strings.Map(unicode.ToLower, "Test")
	strings.Map(func(r rune) rune { return r + 1 }, "shift")
