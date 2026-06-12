# Code to download task contents from find-bare-lang-tags task
package require Tcl 8.5
package require http
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
proc getTaskContent {task} {
    set token [getUrlWithRedirect http://rosettacode.org/mw/index.php \
	    title $task action raw]
    set content [http::data $token]
    http::cleanup $token
    return $content
}

# Code to extract the first <syntaxhighlight lang="text"> section for a language
proc getTaskCodeForLanguage {task language} {
    set content [getTaskContent $task]
    set startRE {==\s*\{\{header\|@LANG@(?:\|[^{}]+)?\}\}\s*==}
    set startRE [string map [list @LANG@ $language] $startRE]
    if {![regexp -indices $startRE $content start]} {
	error "$language does not implement task \"$task\""
    }
    if {![regexp -indices -start [lindex $start end] \
	      "==\\s*\\\{\\\{header" $content end]} {
	set end {end end}
    }
    set content [string range $content [lindex $start 1] [lindex $end 0]]
    # Extended format RE used to allow embedding within _this_ task's <syntaxhighlight lang="text">!
    if {![regexp {(?x)<syntaxhighlight lang=".*?">(.*?)</ lang>} $content -> solution]} {
	error "$language solution of task \"$task\" has no useful code"
    }
    return "$solution\n"
}

# How to download and run a Tcl task
proc runTclTaskForLanguage {task} {
    puts "Fetching task solution..."
    set solution [getTaskCodeForLanguage $task Tcl]
    set filename rcsoln_[string map {/ _ " " _} $task].tcl
    set f [open $filename w]
    puts $f $solution
    close $f
    puts "Executing task solution with: tclsh $filename"
    exec [info nameofexecutable] $filename <@stdin >@stdout 2>@stderr
}
runTclTaskForLanguage {*}$argv
