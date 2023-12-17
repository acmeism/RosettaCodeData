[First Second] | each {input $"($in) integer: "| into int} | [
	[($in.0 < $in.1) "less than"]
	[($in.0 == $in.1) "equal to"]
	[($in.0 > $in.1) "greater than"]
] | each {if $in.0 {$"The first integer is ($in.1) the second integer."}} | str join "\n"
