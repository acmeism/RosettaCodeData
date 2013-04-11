proc question {var message} {
    upvar 1 $var v
    puts -nonewline "$message: "
    flush stdout
    gets stdin $v
}
question name "What is your name"
question task "What is your quest"
question doom "What is the air-speed velocity of an unladen swallow"
