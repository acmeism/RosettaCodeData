package require Tcl 8.6

# A memoization engine, from http://wiki.tcl.tk/18152
oo::class create cache {
    filter Memoize
    variable ValueCache
    method Memoize args {
        # Do not filter the core method implementations
        if {[lindex [self target] 0] eq "::oo::object"} {
            return [next {*}$args]
        }

        # Check if the value is already in the cache
        set key [self target],$args
        if {[info exist ValueCache($key)]} {
            return $ValueCache($key)
        }

        # Compute value, insert into cache, and return it
        return [set ValueCache($key) [next {*}$args]]
    }
    method flushCache {} {
        unset ValueCache
        # Skip the cacheing
        return -level 2 ""
    }
}

# Make an object, attach the cache engine to it, and define ack as a method
oo::object create cached
oo::objdefine cached {
    mixin cache
    method ack {m n} {
        if {$m==0} {
            expr {$n+1}
        } elseif {$m==1} {
            # From the Mathematica version
            expr {$m+2}
        } elseif {$m==2} {
            # From the Mathematica version
            expr {2*$n+3}
        } elseif {$m==3} {
            # From the Mathematica version
            expr {8*(2**$n-1)+5}
        } elseif {$n==0} {
            tailcall my ack [expr {$m-1}] 1
        } else {
            tailcall my ack [expr {$m-1}] [my ack $m [expr {$n-1}]]
        }
    }
}

# Some small tweaks...
interp recursionlimit {} 100000
interp alias {} ack {} cacheable ack
