package require Tcl 8.5
package require ip

proc parseIP {address} {
    set result {}
    set family [ip::version $address]
    set port -1
    if {$family == -1} {
    if {[regexp {^\[(.*)\]:(\d+)$} $address -> address port]} {
        dict set result port $port
        set family [ip::version $address]
        if {$family != 6} {
        return -code error "bad address"
        }
    } elseif {[regexp {^(.*):(\d+)$} $address -> address port]} {
        dict set result port $port
        set family [ip::version $address]
        if {$family != 4} {
        return -code error "bad address"
        }
    } else {
        return -code error "bad address"
    }
    }
    # Only possible error in ports is to be too large an integer
    if {$port > 65535} {
    return -code error "bad port"
    }
    dict set result family $family
    if {$family == 4} {
    # IPv4 normalized form is dotted quad, but toInteger helps
    dict set result addr [format %x [ip::toInteger $address]]
    } else {
    # IPv6 normalized form is colin-separated hex
    dict set result addr [string map {: ""} [ip::normalize $address]]
    }
    # Return the descriptor dictionary
    return $result
}
