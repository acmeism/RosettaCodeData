foreach testNumber {
    49927398716
    49927398717
    1234567812345678
    1234567812345670
} {
    puts [format "%s is %s" $testNumber \
	      [lindex {"NOT valid" "valid"} [luhn $testNumber]]]
}
