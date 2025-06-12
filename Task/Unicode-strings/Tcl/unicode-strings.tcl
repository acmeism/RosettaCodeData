# list of sequential integers
proc range { n m } {
    set res {}
     while {$n <= $m} {lappend  res $n ; incr n }
     return $res
}

# print utf-8 char from integer range
proc utf8_range {n m {enc utf-8} } {

    # save encoding
    set old_enc  [encoding system]

    set streams [list stdin stdout stderr]

    # set new encoding
    encoding system $enc

    foreach stream $streams {
	fconfigure $stream -encoding $enc
    }

    set n [range $n $m]

    set len 0

    # convert int to char in encoding
    # print 30 per line
    foreach c $n {
	set s    [encoding convertto $enc $c]
	set char [format %c $s]
	puts -nonewline "${char}  "
	if {[expr {$len % 19}] == 0} {puts ""}
	incr len
    }

    puts ""

    #restore encoding
    foreach stream $streams {
	fconfigure $stream -encoding $old_enc
    }
    encoding system $old_enc
}


# utf-8 graphics
scan 2580 %x start
scan 27FF %x stop

puts "utf-8 glyphs"
utf8_range $start $stop
