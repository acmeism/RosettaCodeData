foreach sample {
    "1001110011" "1110111011" "0010010010" "1010101010" "1111111111"
    "0100101101" "0100100" "101" "11" "00" "1"
} {
    if {[catch {
	set rep [repstring $sample]
	puts [format "\"%s\" has repetition (length: %d) of \"%s\"" \
		  $sample [string length $rep] $rep]
    }]} {
	puts [format "\"%s\" is not a repeated string" $sample]
    }
}
