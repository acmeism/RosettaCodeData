@ i=99
set s=s
while ($i > 0)
	echo "$i bottle$s of beer on the wall"
	echo "$i bottle$s of beer"
	echo "Take one down, pass it around"
	@ i = $i - 1
	if ($i == 1) then
		set s=
	else
		set s=s
	endif
	echo "$i bottle$s of beer on the wall"
	echo ""
end
