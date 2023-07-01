(StandardFileStream readOnlyFileNamed: 'lesms10.txt')
	contents asLowercase substrings asBag sortedCounts first: 10.
