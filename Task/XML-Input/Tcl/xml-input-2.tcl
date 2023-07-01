package require xml
set parser [xml::parser -elementstartcommand elem]
proc elem {name attlist args} {
    if {$name eq "Student"} {
        puts [dict get $attlist Name]
    }
}
$parser parse $xml
