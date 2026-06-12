proc nysiis {name {truncate false}} {
    # Normalize to first word, uppercased, without non-letters
    set name [regsub -all {[^A-Z]+} [string toupper [regexp -inline {\S+} $name]] ""]
    # Prefix map
    foreach {from to} {MAC MCC KN N K C PH FF PF FF SCH SSS} {
	if {[regsub ^$from $name $to name]} break
    }
    # Suffix map
    foreach {from to} {EE Y IE Y DT D RT D NT D ND D} {
	if {[regsub $from$ $name $to name]} break
    }
    # Split
    regexp (.)(.*) $name -> name rest
    # Reduce suffix
    regsub -all {[AEIOU]} [regsub -all EV $rest AF] A rest
    set rest [string map {Q G Z S M N KN N K C SCH SSS PH FF} $rest]
    regsub -all {([^A])H|(.)H(?=[^A])} $rest {\1\2} rest
    regsub -all AW $rest A rest
    regsub -all {(.)\1+} $rest {\1} rest
    regsub {S$} $rest "" rest
    regsub {A(Y?)$} $rest {\1} rest
    append name $rest
    # Apply truncation if needed
    if {$truncate} {
	set name [string range $name 0 5]
    }
    return $name
}
