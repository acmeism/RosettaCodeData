package require Tcl 8.5

proc fromSexp {str} {
    set tokenizer {[()]|"(?:[^\\""]|\\.)*"|(?:[^()""\s\\]|\\.)+|[""]}
    set stack {}
    set accum {}
    foreach token [regexp -inline -all $tokenizer $str] {
	if {$token eq "("} {
	    lappend stack $accum
	    set accum {}
	} elseif {$token eq ")"} {
	    if {![llength $stack]} {error "unbalanced"}
	    set accum [list {*}[lindex $stack end] [list list {*}$accum]]
	    set stack [lrange $stack 0 end-1]
	} elseif {$token eq "\""} {
	    error "bad quote"
	} elseif {[string match {"*"} $token]} {
	    set token [string range $token 1 end-1]
	    lappend accum [list string [regsub -all {\\(.)} $token {\1}]]
	} else {
	    if {[string is integer -strict $token]} {
		set type int
	    } elseif {[string is double -strict $token]} {
		set type real
	    } else {
		set type atom
	    }
	    lappend accum [list $type [regsub -all {\\(.)} $token {\1}]]
	}
    }
    if {[llength $stack]} {error "unbalanced"}
    return [lindex $accum 0]
}
proc toSexp {tokList} {
    set content [lassign $tokList type]
    if {$type eq "list"} {
	set s "("
	set sep ""
	foreach bit $content {
	    append s $sep [toSexp $bit]
	    set sep " "
	}
	return [append s ")"]
    } elseif {$type eq "string"} {
	return "\"[regsub -all {[\\""]} [lindex $content 0] {\\\0}]\""
    } else {
	return [lindex $content 0]
    }
}
