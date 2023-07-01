package require Tcl 8.6

oo::class create WebSearcher {
    variable page term results
    constructor searchTerm {
        set page 0
        set term $searchTerm
        my nextPage
    }
    # This next method *is* a very Tcl-ish way of doing iteration.
    method for {titleVar contentsVar urlVar body} {
        upvar 1 $titleVar t $contentsVar c $urlVar v
        foreach {t c v} $results {
            uplevel 1 $body
        }
    }
    # Reuse the previous code for simplicity rather than writing it anew
    # Of course, if we were serious about this, we'd put the code here properly
    method nextPage {} {
        set results [YahooSearch $term [incr page]]
        return
    }
}

# How to use. Note the 'foreach' method use below; new "keywords" as methods!
set ytest [WebSearcher new "test"]
$ytest for title - url {
    puts "\"$title\" : $url"
}
$ytest nextPage
$ytest for title - url {
    puts "\"$title\" : $url"
}
$ytest delete ;# standard method that deletes the object
