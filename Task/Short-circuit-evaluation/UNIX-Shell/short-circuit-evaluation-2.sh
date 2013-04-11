alias a eval \''echo "Called a \!:1"; "\!:1"'\'
alias b eval \''echo "Called b \!:1"; "\!:1"'\'

foreach i (false true)
	foreach j (false true)
		a $i && b $j && set x=true || set x=false
		echo "  $i && $j is $x"

		a $i || b $j && set x=true || set x=false
		echo "  $i || $j is $x"
	end
end
