package require Tcl 8.5
package require http
package require json
package require textutil::split
package require uri

proc getUrlWithRedirect {base args} {
    set url $base?[http::formatQuery {*}$args]
    while 1 {
	set t [http::geturl $url]
	if {[http::status $t] ne "ok"} {
	    error "Oops: url=$url\nstatus=$s\nhttp code=[http::code $token]"
	}
	if {[string match 2?? [http::ncode $t]]} {
	    return $t
	}
	# OK, but not 200? Must be a redirect...
	set url [uri::resolve $url [dict get [http::meta $t] Location]]
	http::cleanup $t
    }
}

proc get_tasks {category} {
    global cache
    if {[info exists cache($category)]} {
	return $cache($category)
    }
    set query [dict create cmtitle Category:$category]
    set tasks [list]

    while {1} {
	set response [getUrlWithRedirect http://rosettacode.org/mw/api.php \
		action query list categorymembers format json cmlimit 500 {*}$query]

	# Get the data out of the message
        set data [json::json2dict [http::data $response]]
        http::cleanup $response

        # add tasks to list
        foreach task [dict get $data query categorymembers] {
            lappend tasks [dict get [dict create {*}$task] title]
        }

        if {[catch {
	    dict get $data query-continue categorymembers cmcontinue
	} continue_task]} then {
            # no more continuations, we're done
            break
        }
        dict set query cmcontinue $continue_task
    }
    return [set cache($category) $tasks]
}
proc getTaskContent task {
    set token [getUrlWithRedirect http://rosettacode.org/mw/index.php \
	    title $task action raw]
    set content [http::data $token]
    http::cleanup $token
    return $content
}

proc init {} {
    global total count found
    set total 0
    array set count {}
    array set found {}
}
proc findBareTags {pageName pageContent} {
    global total count found
    set t {{}}
    lappend t {*}[textutil::split::splitx $pageContent \
	    {==\s*\{\{\s*header\s*\|\s*([^{}]+?)\s*\}\}\s*==}]
    foreach {sectionName sectionText} $t {
	set n [regexp -all {<lang>} $sectionText]
	if {!$n} continue
	incr count($sectionName) $n
	lappend found($sectionName) $pageName
	incr total $n
    }
}
proc printResults {} {
    global total count found
    puts "$total bare language tags."
    if {$total} {
	puts ""
	if {[info exists found()]} {
	    puts "$count() in task descriptions\
		    (\[\[[join $found() {]], [[}]\]\])"
	    unset found()
	}
	foreach sectionName [lsort -dictionary [array names found]] {
	    puts "$count($sectionName) in $sectionName\
		    (\[\[[join $found($sectionName) {]], [[}]\]\])"
	}
    }
}

init
set tasks [get_tasks Programming_Tasks]
#puts stderr "querying over [llength $tasks] tasks..."
foreach task [get_tasks Programming_Tasks] {
    #puts stderr "$task..."
    findBareTags $task [getTaskContent $task]
}
printResults
