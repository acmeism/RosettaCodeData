/^([0-9]+(\.[0-9]*)?|\.[0-9]+)([Ee][-+]?[0-9]+)?$/ {
	print $0 " is a literal number."
	next
}

{
	print $0 " is not valid."
}
