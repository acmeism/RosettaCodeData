proc test {} {
    foreach {cusip name} {
        037833100       "Apple Incorporated"
        17275R102       "Cisco Systems"
        38259P508       "Google Incorporated"
        594918104       "Microsoft Corporation"
        68389X106       "Oracle Corporation   (incorrect)"
        68389X105       "Oracle Corporation"
    } {
        puts [format %-40s%s $name [expr {[check-cusip $cusip] ? "valid" : "invalid"}]]
        puts [format %-40s%s $name [expr {[cusip-check $cusip] ? "valid" : "invalid"}]]
    }
}
test
