proc 0-19 {n} {
    lindex {"no more" one two three four five six seven eight nine ten eleven
            twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen} $n
}

proc TENS {n} {
    lindex {twenty thirty fourty fifty sixty seventy eighty ninety} [expr {$n - 2}]
}

proc num2words {n} {
    if {$n < 20} {return [0-19 $n]}
    set tens [expr {$n / 10}]
    set ones [expr {$n % 10}]
    if {$ones == 0} {return [TENS $tens]}
    return "[TENS $tens]-[0-19 $ones]"
}

proc get_words {n} {
    return "[num2words $n] bottle[expr {$n != 1 ? "s" : ""}] of beer"
}

for {set i 99} {$i > 0} {incr i -1} {
    puts [string totitle "[get_words $i] on the wall, [get_words $i]."]
    puts "Take one down and pass it around, [get_words [expr {$i - 1}]] on the wall.\n"
}

puts "No more bottles of beer on the wall, no more bottles of beer."
puts "Go to the store and buy some more, 99 bottles of beer on the wall."
