if2 {test 1 -gt 0} {~ grill foo bar boo} {
	echo 1 and 2
} {
	echo 1 but not 2
} {
	echo 2 but not 1
} {
	echo neither 1 nor 2
}
