proc ask_yn {prompt} {

    puts "${prompt} ?"
    set answer ""
    set valid 0

    while {! $valid} {

	    gets stdin answer

	    switch -nocase -glob $answer {
	        Y*  { set valid 1; set answer Y }
	        N*  { set valid 1; set answer N }
	        default {}
	    }
	
	    if {!$valid} {puts "Choose either Y or N"}	
    }

    return [expr $answer == Y]
}

set prompt "Is this correct? (Y/N)"

set ans [ask_yn $prompt]

if {$ans} {
    puts "answer was Yes"
} else {
    puts "answer was No"
}
