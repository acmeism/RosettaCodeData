puts -nonewline "Enter a variable name: "; flush stdout
gets stdin varname
upvar 0 $varname v; # The ‘0’ for “current scope”
set v [expr int(rand()*100)]
puts "I have set variable $varname to $v (see for yourself: [set $varname])"
