package require http

proc fix s {
    string map {<b>...</b> "" <b> "" </b> "" <wbr> "" "<wbr />" ""} \
            [regsub "</a></h3></div>.*" $s ""]
}
proc YahooSearch {term {page 1}} {
    # Build the (ugly) scraper URL
    append re {<a class="yschttl spt" href=".+?" >(.+?)</a></h3>}
    append re {</div><div class="abstr">(.+?)}
    append re {</div><span class=url>(.+?)</span>}

    # Perform the query; note that this handles special characters
    # in the query term correctly
    set q [http::formatQuery p $term b [expr {$page*10-9}]]
    set token [http::geturl http://search.yahoo.com/search?$q]
    set data [http::data $token]
    http::cleanup $token

    # Assemble the results into a nice list
    set results {}
    foreach {- title content url} [regexp -all -inline $re $data] {
        lappend results [fix $title] [fix $content] [fix $url]
    }

    # set up the call for the next page
    interp alias {} Nextpage {} YahooSearch $term [incr page]

    return $results
}

# Usage:  get the first two pages of results
foreach {title content url} [YahooSearch "test"] {
    puts $title
}
foreach {title content url} [Nextpage] {
     puts $title
}
