package require TclOO

oo::class create Delegate {
    method thing {} {
        return "delegate impl."
    }
    export thing
}

oo::class create Delegator {
    variable delegate
    constructor args {
        my delegate {*}$args
    }

    method delegate args {
        if {[llength $args] == 0} {
            if {[info exists delegate]} {
                return $delegate
            }
        } elseif {[llength $args] == 1} {
            set delegate [lindex $args 0]
        } else {
            return -code error "wrong # args: should be \"[self] delegate ?target?\""
        }
    }

    method operation {} {
        try {
            set result [$delegate thing]
        } on error e {
            set result "default implementation"
        }
        return $result
    }
}

# to instantiate a named object, use: class create objname; objname aMethod
# to have the class name the object:  set obj [class new]; $obj aMethod

Delegator create a
set b [Delegator new "not a delegate object"]
set c [Delegator new [Delegate new]]

assert {[a operation] eq "default implementation"}   ;# a "named" object, hence "a ..."
assert {[$b operation] eq "default implementation"}  ;# an "anonymous" object, hence "$b ..."
assert {[$c operation] ne "default implementation"}

# now, set a delegate for object a
a delegate [$c delegate]
assert {[a operation] ne "default implementation"}

puts "all assertions passed"
