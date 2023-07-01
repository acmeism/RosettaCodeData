(StandardFileStream new open: 'lesms10.txt' forWrite: false)
	contents asLowercase substrings asBag sortedCounts first: 10.
