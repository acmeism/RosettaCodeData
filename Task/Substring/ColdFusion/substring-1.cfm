<cfoutput>
	<cfset str = "abcdefg">
	<cfset n = 2>
	<cfset m = 3>

	<!--- Note: In CF index starts at 1 rather than 0
	starting from n characters in and of m length --->
	#mid( str, n, m )#
	<!--- starting from n characters in, up to the end of the string --->
	<cfset countFromRight = Len( str ) - n + 1>
	#right( str, countFromRight )#
	<!--- whole string minus last character --->
	<cfset allButLast = Len( str ) - 1>
	#left( str, allButLast )#
	<!--- starting from a known character within the string and of m length --->
	<cfset startingIndex = find( "b", str )>
	#mid( str, startingIndex, m )#
	<!--- starting from a known substring within the string and of m length --->
	<cfset startingIndexSubString = find( "bc", str )>
	#mid( str, startingIndexSubString, m )#

</cfoutput>
