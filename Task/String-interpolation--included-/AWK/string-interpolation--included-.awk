#!/usr/bin/awk -f
BEGIN {
	str="Mary had a # lamb; # and blue.";
	gsub(/#/,"big",str);
	print str;
}
