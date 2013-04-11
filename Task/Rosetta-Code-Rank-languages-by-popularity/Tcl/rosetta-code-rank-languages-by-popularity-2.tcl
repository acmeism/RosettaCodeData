package require Tcl 8.5
package require http
package require tdom

namespace eval rc {
    ### Utility function that handles the low-level querying ###
    proc rcq {q xp vn b} {
	upvar 1 $vn v
	dict set q action "query"
        # Loop to pick up all results out of a category query
	while 1 {
	    set url "http://rosettacode.org/mw/api.php?[http::formatQuery {*}$q]"
	    puts -nonewline stderr .		;# Indicate query progress...
	    set token [http::geturl $url]
	    set doc [dom parse [http::data $token]]
	    http::cleanup $token

	    # Spoon out the DOM nodes that the caller wanted
	    foreach v [$doc selectNodes $xp] {
		uplevel 1 $b
	    }

	    # See if we want to go round the loop again
	    set next [$doc selectNodes "//query-continue/categorymembers"]
	    if {![llength $next]} break
	    dict set q cmcontinue [[lindex $next 0] getAttribute "cmcontinue"]
	}
    }

    ### API function: Iterate over the members of a category ###
    proc members {page varName script} {
	upvar 1 $varName var
	set query [dict create cmtitle "Category:$page" {*}{
	    list "categorymembers"
	    format "xml"
	    cmlimit "500"
	}]
	rcq $query "//cm" item {
	    # Tell the caller's script about the item
	    set var [$item getAttribute "title"]
	    uplevel 1 $script
	}
    }

    ### API function: Count the members of a list of categories ###
    proc count {cats catVar countVar script} {
	upvar 1 $catVar cat $countVar count
	set query [dict create prop "categoryinfo" format "xml"]
	for {set n 0} {$n<[llength $cats]} {incr n 40} {
	    dict set query titles [join [lrange $cats $n $n+39] |]
	    rcq $query "//page" item {
		# Get title and count
		set cat [$item getAttribute "title"]
		set info [$item getElementsByTagName "categoryinfo"]
		if {[llength $info]} {
		    set count [[lindex $info 0] getAttribute "pages"]
		} else {
		    set count 0
		}
		# Let the caller's script figure out what to do with them
		uplevel 1 $script
	    }
	}
    }

    ### Assemble the bits into a whole API ###
    namespace export members count
    namespace ensemble create
}

# Get the list of programming languages
rc members "Solutions by Programming Language" lang {
    lappend langs $lang
}
# Get the count of solutions for each, stripping "Category:" prefix
rc count $langs l c {
    lappend count [list [regsub {^Category:} $l {}] $c]
}
puts stderr ""			;# Because of the progress dots...
# Print the output
puts "There are [llength $count] languages"
puts "Here are the top fifteen:"
set count [lsort -index 1 -integer -decreasing $count]
foreach item [lrange $count 0 14] {
    puts [format "%1\$3d. %3\$3d - %2\$s" [incr n] {*}$item]
}
