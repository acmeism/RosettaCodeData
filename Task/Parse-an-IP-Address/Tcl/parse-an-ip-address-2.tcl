foreach address {
    127.0.0.1
    127.0.0.1:80
    ::1
    [::1]:80
    2605:2700:0:3::4713:93e3
    [2605:2700:0:3::4713:93e3]:80
    ::ffff:192.168.0.1
    [::ffff:192.168.0.1]:22
    ::ffff:127.0.0.0.1
    a::b::1
    127.0.0.1:100000
} {
    if {[catch {
	set parsed [parseIP $address]
    } msg]} {
	puts "error ${msg}: \"$address\""
	continue
    }
    dict with parsed {
	puts -nonewline "family: IPv$family addr: $addr"
	if {[dict exists $parsed port]} {
	    puts -nonewline " port: $port"
	}
	puts ""
    }
}
