proc isleap1 {year} {
    return [expr {($year % 4 == 0) && (($year % 100 != 0) || ($year % 400 == 0))}]
}
isleap1 1988 ;# => 1
isleap1 1989 ;# => 0
isleap1 1900 ;# => 0
isleap1 2000 ;# => 1
