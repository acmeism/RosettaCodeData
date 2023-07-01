foreach n {
    123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345
    1 2 -1 -10 2002 -2002 0
} {
    if {[catch {
	set mid [middleThree $n]
    } msg]} then {
	puts "error for ${n}: $msg"
    } else {
	puts "found for ${n}: $mid"
    }
}
