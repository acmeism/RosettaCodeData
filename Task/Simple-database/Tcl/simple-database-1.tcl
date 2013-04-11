#!/usr/bin/env tclsh8.6
package require Tcl 8.6
namespace eval udb {
    variable db {}

    proc Load {filename} {
	variable db
	if {[catch {set f [open $filename]}]} {
	    set db {}
	    return
	}
	set db [read $f]
	close $f
    }
    proc Store {filename} {
	variable db
	if {[catch {set f [open $filename w]}]} return
	dict for {nm inf} $db {
	    puts $f [list $nm $inf]
	}
	close $f
    }

    proc add {title category {date "now"} args} {
	variable db
	if {$date eq "now"} {
	    set date [clock seconds]
	} else {
	    set date [clock scan $date]
	}
	dict set db $title [list $category $date $args]
	return
    }
    proc Rec {nm cat date xtra} {
	dict create description $nm category $cat date [clock format $date] \
	    {*}$xtra _names [dict keys $xtra]
    }
    proc latest {{category ""}} {
	variable db
	if {$category eq ""} {
	    set d [lsort -stride 2 -index {1 1} -integer -decreasing $db]
	    dict for {nm inf} $d break
	    return [list [Rec $nm {*}$inf]]
	}
	set latestbycat {}
	dict for {nm inf} [lsort -stride 2 -index {1 1} -integer $db] {
	    dict set latestbycat [lindex $inf 0] [list $nm {*}$inf]
	}
	return [list [Rec {*}[dict get $latestbycat $category]]]
    }
    proc latestpercategory {} {
	variable db
	set latestbycat {}
	dict for {nm inf} [lsort -stride 2 -index {1 1} -integer $db] {
	    dict set latestbycat [lindex $inf 0] [list $nm {*}$inf]
	}
	set result {}
	dict for {- inf} $latestbycat {
	    lappend result [Rec {*}$inf]
	}
	return $result
    }
    proc bydate {} {
	variable db
	set result {}
	dict for {nm inf} [lsort -stride 2 -index {1 1} -integer $db] {
	    lappend result [Rec $nm {*}$inf]
	}
	return $result
    }

    namespace export add latest latestpercategory bydate
    namespace ensemble create
}

if {$argc < 2} {
    puts stderr "wrong # args: should be \"$argv0 dbfile subcommand ?args...?\""
    exit 1
}
udb::Load [lindex $argv 0]
set separator ""
if {[catch {udb {*}[lrange $argv 1 end]} msg]} {
    puts stderr [regsub "\"udb " $msg "\"$argv0 dbfile "]
    exit 1
}
foreach row $msg {
    puts -nonewline $separator
    apply {row {
	dict with row {
	    puts "Title: $description"
	    puts "Category: $category"
	    puts "Date: $date"
	    foreach v $_names {
		puts "${v}: [dict get $row $v]"
	    }
	}
    }} $row
    set separator [string repeat - 70]\n
}

udb::Store [lindex $argv 0]
