#!/usr/bin/env tclsh

proc vowels {s} {
    set count 0
    set vowels  [list a e i o u y]
    set letters [split $s ""]

    foreach l $letters {	
	    if {$l in $vowels} {
	        incr count
	    }
    }
    return $count
}

proc consonants {s} {
    set count 0
    set vowels  [list a e i o u y]
    set letters [split $s ""]

    foreach l $letters {	
	    if {$l ni $vowels  && [string is alpha $l]} {
	        incr count
	    }
    }
    return $count
}

proc unique {list} {
  set new {}
    foreach item $list {
        if {$item ni $new} {lappend new $item}
    }
    return $new
}


proc unique_string {s} {
    set letters [split $s ""]
    set u       [unique $letters]
    return [join $$u ""]
}


set S "Now is the time for all good men to come to the aid of their country."

puts stdout "There are unique [vowels [unique_string $S]] vowels."
puts stdout "There are [vowels $S] total vowels."

puts stdout "There are unique [consonants [unique_string $S]] consonants."
puts stdout "There are [consonants $S] total consonants."

# used regex  to count matching letters
puts "using regexp:"

set c [regexp -all -nocase {[bcdfghjklmnpqrstvwxz]} $S]
puts "\t$c consonants"

set v [regexp -all -nocase {[aeiouy]} $S]
puts "\t $v vowels"
