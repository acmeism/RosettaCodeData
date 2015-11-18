package require struct::list

set have { \
    ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC \
    ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB \
}

struct::list foreachperm element {A B C D} {
	set text [join $element ""]
	if {$text ni $have} {
		puts "Missing permutation(s): $text"
	}
}
