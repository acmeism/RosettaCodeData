on printConsole(x)
	return x as string
end printConsole

set {i, table} to {0, {return}}
repeat while (i mod 6 is not 0 or i is not 6)
	set i to i + 1
	set end of table to i & return
	printConsole(table)
end repeat
