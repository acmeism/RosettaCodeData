if2 'test 7 -lt 9' 'test 7 -gt 9' '
	echo both 1 and 2
' '
	echo 1 but not 2
' '
	echo 2 but not 1
' '
	echo neither 1 nor 2
'
