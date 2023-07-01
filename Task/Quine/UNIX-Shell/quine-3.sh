{
	string=`cat`
	printf "$string" "$string"
	echo
	echo END-FORMAT
} <<'END-FORMAT'
{
	string=`cat`
	printf "$string" "$string"
	echo
	echo END-FORMAT
} <<'END-FORMAT'
%s
END-FORMAT
