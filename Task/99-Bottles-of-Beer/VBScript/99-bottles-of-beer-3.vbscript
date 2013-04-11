function pluralBottles( n )
	select case n
	case 1
		pluralBottles = "one bottle"
	case 0
		pluralBottles = "no more bottles"
	case else
		pluralBottles = n & " bottles"
	end select
end function

function eef( b, r1, r2 )
	if b then
		eef = r1
	else
		eef = r2
	end if
end function

Function evalEmbedded(sInput, sP1)
	dim oRe, oMatch, oMatches
	dim sExpr, sResult
	Set oRe = New RegExp
	'Look for expressions as enclosed in braces
	oRe.Pattern = "{(.+?)}"
	sResult = sInput
	do
		Set oMatches = oRe.Execute(sResult)
		if oMatches.count = 0 then exit do
		for each oMatch in oMatches
			'~ wscript.echo oMatch.Value
			for j = 0 to omatch.submatches.count - 1
				sExpr = omatch.submatches(j)
				sResult  = Replace( sResult, "{" & sExpr & "}", eval(sExpr) )
			next
		next
	loop
	evalEmbedded = sResult
End Function

sub sing( numBottles )
	dim i
	for i = numBottles to 0 step -1
		if i = 0 then
			wscript.echo evalEmbedded("no more bottles of beer on the wall" & vbNewline & _
						"no more bottles of beer" & vbNewline & _
						"go to the store and buy some more" & vbNewline & _
						"{pluralBottles(sP1)} of beer on the wall" & vbNewline, numBottles)
		else
			wscript.echo evalEmbedded("{pluralBottles(sP1)} of beer on the wall" & vbNewline & _
					      "{pluralBottles(sP1)} of beer" & vbNewline & _
					      "take {eef(sP1=1,""it"",""one"")} down and pass it round" & vbNewline & _
					      "{pluralBottles(sP1-1)} of beer on the wall" & vbNewline, i)
		end if
	next
end sub

sing 3
