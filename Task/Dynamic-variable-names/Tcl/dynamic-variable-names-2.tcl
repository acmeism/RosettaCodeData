puts -nonewline "Enter an element name: "; flush stdout
gets stdin elemname
set ary($elemname) [expr int(rand()*100)]
puts "I have set element $elemname to $ary($elemname)"
