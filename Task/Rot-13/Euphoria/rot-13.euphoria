include std/types.e
include std/text.e

atom FALSE = 0
atom TRUE = not FALSE

function Rot13( object oStuff )
	integer iOffset
	integer bIsUpper
	object oResult
	sequence sAlphabet = "abcdefghijklmnopqrstuvwxyz"
	if sequence(oStuff) then
		oResult = repeat( 0, length( oStuff ) )
		for i = 1 to length( oStuff ) do
			oResult[ i ] = Rot13( oStuff[ i ] )
		end for
	else
		bIsUpper = FALSE
		if t_upper( oStuff ) then
			bIsUpper = TRUE
			oStuff = lower( oStuff )
		end if
		iOffset = find( oStuff, sAlphabet )
		if iOffset != 0 then
			iOffset += 13
			iOffset = remainder( iOffset, 26 )
			if iOffset = 0 then iOffset = 1 end if
			oResult = sAlphabet[iOffset]
			if bIsUpper then
				oResult = upper(oResult)
			end if
		else
			oResult = oStuff --sprintf( "%s", oStuff )
		end if
	end if
	return oResult
end function

puts( 1, Rot13( "abjurer NOWHERE." ) & "\n" )
