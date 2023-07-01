package require tdom
set tree [dom parse $xml]
set studentNodes [$tree getElementsByTagName Student] ;# or: set studentNodes [[$tree documentElement] childNodes]

foreach node $studentNodes {
    puts [$node getAttribute Name]
}
