# From http://wiki.tcl.tk/9547
package require Tcl         8.5
package provide datatype    0.1

namespace eval ::datatype {
    namespace export define match matches
    namespace ensemble create

    # Datatype definitions
    proc define {type = args} {
        set ns [uplevel 1 { namespace current }]
        foreach cons [split [join $args] |] {
            set name [lindex $cons 0]
            set args [lrange $cons 1 end]
            proc $ns\::$name $args [format {
                lreplace [info level 0] 0 0 %s
            } [list $name]]
        }
        return $type
    }

    # Pattern matching
    # matches pattern value envVar --
    #   Returns 1 if value matches pattern, else 0
    #   Binds match variables in envVar
    proc matches {pattern value envVar} {
        upvar 1 $envVar env
        if {[var? $pattern]} { return [bind env $pattern $value] }
        if {[llength $pattern] != [llength $value]} { return 0 }
        if {[lindex $pattern 0] ne [lindex $value 0]} { return 0 }
        foreach pat [lrange $pattern 1 end] val [lrange $value 1 end] {
            if {![matches $pat $val env]} { return 0 }
        }
        return 1
    }
    # A variable starts with lower-case letter or _. _ is a wildcard.
    proc var? term { string match {[a-z_]*} $term }
    proc bind {envVar var value} {
        upvar 1 $envVar env
        if {![info exists env]} { set env [dict create] }
        if {$var eq "_"} { return 1 }
        dict set env $var $value
        return 1
    }
    proc match args {
        #puts "MATCH: $args"
        set values [lrange $args 0 end-1]
        set choices [lindex $args end]
        append choices \n [list return -code error -level 2 "no match for $values"]
        set f [list values $choices [namespace current]]
        lassign [apply $f $values] env body
        #puts "RESULT: $env -> $body"
        dict for {k v} $env { upvar 1 $k var; set var $v }
        catch { uplevel 1 $body } msg opts
        dict incr opts -level
        return -options $opts $msg
    }
    proc case args {
        upvar 1 values values
        set patterns [lrange $args 0 end-2]
        set body [lindex $args end]
        set env [dict create]
        if {[llength $patterns] != [llength $values]} { return }
        foreach pattern $patterns value $values {
            if {![matches $pattern $value env]} { return }
        }
        return -code return [list $env $body]
    }
    proc default body { return -code return [list {} $body] }
}
