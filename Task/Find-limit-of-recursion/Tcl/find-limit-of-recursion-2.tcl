# Increase the maximum depth
interp recursionlimit {} 1000000
proc recur i {
    if {[catch {recur [incr i]}]} {
        # If we failed to recurse, print how far we got
	puts "Got to depth $i"
    }
}
recur 0
