# A nicer way to print the evidence of vampire-ness
proc printVampire {n pairs} {
    set out "${n}:"
    foreach p $pairs {
	append out " \[[join $p {, }]\]"
    }
    puts $out
}
set n 0
for {set i 0} {$i < 25} {incr i} {
    while 1 {
	if {[llength [set vamps [vampireFactors [incr n]]]]} {
	    printVampire $n $vamps
	    break
	}
    }
}
puts ""
foreach n {16758243290880 24959017348650 14593825548650} {
    if {[llength [set vamps [vampireFactors $n]]]} {
	printVampire $n $vamps
    } else {
	puts "$n is not a vampire number"
    }
}
