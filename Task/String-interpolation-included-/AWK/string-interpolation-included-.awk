#!/usr/bin/awk -f
BEGIN {
	str="Mary had a # lamb."
	gsub(/#/, "little", str)
	print str
}
