puts "Enter a variable name:"
gets stdin varname
set $varname 42
puts "I have set variable $varname to [set $varname]"
