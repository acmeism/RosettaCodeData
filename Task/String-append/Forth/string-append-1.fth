Strings in Forth are simply named memory locations

create astring  256 allot   \ create a "string"

s" Hello " astring PLACE     \ initialize the string

s" World!" astring +PLACE   \ append with "+place"
