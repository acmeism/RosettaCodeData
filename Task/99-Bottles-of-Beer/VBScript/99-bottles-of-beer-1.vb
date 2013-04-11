sub song( numBottles )
	dim i
	for i = numBottles to 0 step -1
		if i > 0 then
			wscript.echo pluralBottles(i) & " of beer on the wall"
			wscript.echo pluralBottles(i) & " of beer"
			if i = 1 then
				wscript.echo "take it down"
			else
				wscript.echo "take one down"
			end if
			wscript.echo "and pass it round"
			wscript.echo pluralBottles(i-1) & " of beer on the wall"
			wscript.echo
		else
			wscript.echo "no more bottles of beer on the wall"
			wscript.echo "no more bottles of beer"
			wscript.echo "go to the store"
			wscript.echo "and buy some more"
			wscript.echo pluralBottles(numBottles) & " of beer on the wall"
			wscript.echo
		end if
	next
end sub
	
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

song 3
