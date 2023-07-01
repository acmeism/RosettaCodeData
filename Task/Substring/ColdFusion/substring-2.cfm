<cfscript>
	str="abcdefg";
	n = 2;
	m = 3;

	// Note: In CF index starts at 1 rather than 0
	// starting from n characters in and of m length
	writeOutput( mid( str, n, m ) );
	// starting from n characters in, up to the end of the string
	countFromRight = Len( str ) - n + 1;
	writeOutput( right( str, countFromRight ) );
	// whole string minus last character
	allButLast = Len( str ) - 1;
	writeOutput( left( str, allButLast ) );
	// starting from a known character within the string and of m length
	startingIndex = find( "b", str );
	writeOutput( mid( str, startingIndex, m ) );
	// starting from a known substring within the string and of m length
	startingIndexSubString = find( "bc", str );
	writeOutput( mid( str, startingIndexSubString, m ) );
</cfscript>
