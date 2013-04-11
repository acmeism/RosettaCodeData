package require Tcl 8.5
package require http

set response [http::geturl http://rosettacode.org/mw/index.php?title=Special:Categories&limit=1000]

array set ignore {
    "Basic language learning"           1
    "Encyclopedia"                      1
    "Implementations"                   1
    "Language Implementations"          1
    "Language users"                    1
    "Maintenance/OmitCategoriesCreated" 1
    "Programming Languages"             1
    "Programming Tasks"                 1
    "RCTemplates"                       1
    "Solutions by Library"              1
    "Solutions by Programming Language" 1
    "Solutions by Programming Task"     1
    "Unimplemented tasks by language"   1
    "WikiStubs"                         1
    "Examples needing attention"	1
    "Impl needed"			1	
}

foreach line [split [http::data $response] \n] {
    if {[regexp {>([^<]+)</a> \((\d+) member} $line -> lang num]} {
        if {![info exists ignore($lang)]} {
            lappend langs [list $num $lang]
        }
    }
}

foreach entry [lsort -integer -index 0 -decreasing $langs] {
    lassign $entry num lang
    puts [format "%d. %d - %s" [incr i] $num $lang]
}
