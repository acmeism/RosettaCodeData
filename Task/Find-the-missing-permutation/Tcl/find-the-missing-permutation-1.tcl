package require struct::list
package require struct::set

# Make complete list of permutations of a string of characters
proc allCharPerms s {
    set perms {}
    set p [struct::list firstperm [split $s {}]]
    while {$p ne ""} {
	lappend perms [join $p {}]
	set p [struct::list nextperm $p]
    }
    return $perms
}

# The set of provided permutations (wrapped for convenience)
set have {
    ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC
    ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB
}
# Get the real list of permutations...
set all [allCharPerms [lindex $have 0]]
# Find the missing one(s)!
set missing [struct::set difference $all $have]
puts "missing permutation(s): $missing"
