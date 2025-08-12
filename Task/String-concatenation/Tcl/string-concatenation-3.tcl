set s "Hello"
set w "World"
set hw "$s $w"                ; #  "hello world"
set hw [concat $s $w]         ; #  {hello world}, same as above
set hw [string cat $s $w]     ; #  "helloworld"
set hw [join [list $s $w] " "] ; #  "hello world"  \w space delimiter
