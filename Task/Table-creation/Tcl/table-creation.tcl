proc table_update {_tbl row args} {
    upvar $_tbl tbl
    set heads [lindex $tbl 0]
    if {$row eq "end+1"} {
        lappend tbl [lrepeat [llength $heads] {}]
        set row [expr [llength $tbl]-1]
    }
    foreach {key val} $args {
        set col [lsearch $heads $key*]
        foreach {name type} [split [lindex $heads $col] |] break
        if {$type eq "float"} {set type double}
        if {$type eq "date"} {
            if [catch {clock scan $val}] {
                error "bad date value $val"
            }
        } elseif {$type ne ""} {
            if ![string is $type -strict $val] {
                error "bad $type value $val"
            }
        }
        lset tbl $row $col $val
    }
}
proc table_format table {
    set maxs {}
    foreach item [lindex $table 0] {
        set item [lindex [split $item |] 0]
        lappend maxs [string length $item]
    }
    foreach row [lrange $table 1 end] {
        set i 0
        foreach item $row max $maxs {
            if {[string length $item]>$max} {lset maxs $i [string length $item]}
            incr i
        }
    }
    set head +
    foreach max $maxs {append head -[string repeat - $max]-+}
    set res $head\n
    foreach row $table {
        if {$row eq [lindex $table 0]} {
            regsub -all {\|[^ ]+} $row "" row
        }
        append res |
        foreach item $row max $maxs {
             append res [format " %-${max}s |" $item]
        }
        append res \n
        if {$row eq [lindex $table 0]} {
            append res $head \n
        }
    }
    append res $head
}
#------------------------------------- Test and demo:
set mytbl [list [list \
                     account_id|int \
                     created|date  \
                     active|bool \
                     username \
                     balance|float \
                    ]]

table_update mytbl end+1 \
    account_id 12345 \
    username   "John Doe" \
    balance    0.0 \
    created    2009-05-13

table_update mytbl end+1 \
    account_id 12346 \
    username   "Jane Miller" \
    balance    0.0 \
    created    2009-05-14
puts [table_format $mytbl]
