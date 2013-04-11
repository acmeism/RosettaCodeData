proc isleap2 year {
    return [expr {[clock format [clock scan "$year-02-29" -format "%Y-%m-%d"] -format "%m-%d"] eq "02-29"}]
}
isleap2 1988 ;# => 1
isleap2 1989 ;# => 0
isleap2 1900 ;# => 0
isleap2 2000 ;# => 1
