package require Tcl 8.6
package require http
package require htmlparse
package require textutil::adjust

oo::class create yahoosearch {

    method search {s} {
        my variable searchterm page baseurl
        set searchterm $s
        set page 1
        set baseurl {http://ca.search.yahoo.com/search}
    }

    method getresults {} {
        my variable state results current_data
        set results [list]
        set current_data [dict create]
        set state looking_for_results
        htmlparse::parse -cmd [list [self] html_parser_callback] [my gethtml]
    }

    method nextpage {} {
        my variable page
        incr page 10
        my getresults
    }

    method nextresult {} {
        my variable results page
        if { ! [info exists results]} {
            my getresults
        } elseif {[llength $results] == 0} {
            my nextpage
        }
        set results [lassign $results result]
        return $result
    }

    method gethtml {} {
        my variable searchterm page baseurl
        set url [format {%s?%s} $baseurl [::http::formatQuery p $searchterm b $page]]
        set response [http::geturl $url]
        set html [http::data $response]
        http::cleanup $response
        return $html
    }

    method html_parser_callback {tag slash param textBehindTheTag} {
        my variable state results current_data
        switch -exact -- $state {
            looking_for_results {
                if {$tag eq "div" && [string first {id="main"} $param] != -1} {
                    set state ready
                }
            }
            ready {
                if {($tag eq "div" && [string first {class="res} $param] != -1) ||
                    ($tag eq "html" && $slash eq "/")
                } { #" -- unbalanced quote disturbs syntax highlighting
                    if {[dict size $current_data] > 0} {lappend results $current_data}
                    set current_data [dict create]
                    set state getting_url
                }
            }
            getting_url {
                if {$tag eq "a" && [string match "*yschttl spt*" $param]} {
                    if {[regexp {href="(.+?)"} $param - url]} {
                        dict set current_data url $url
                    } else {
                        dict set current_data url "no href in tag params: '$param'"
                    }
                    dict set current_data title $textBehindTheTag
                    set state getting_title
                }
            }
            getting_title {
                if {$tag eq "a" && $slash eq "/"} {
                    set state looking_for_abstract
                } else {
                    dict append current_data title $textBehindTheTag
                }
            }
            looking_for_abstract {
                if {$tag eq "span" && [string first {class="url} $param] != -1} {
                    set state ready
                } elseif {$tag eq "div" && [string first {class="abstr} $param] != -1} {
                    dict set current_data abstract $textBehindTheTag
                    set state getting_abstract
                }
            }
            getting_abstract {
                if {$tag eq "div" && $slash eq "/"} {
                    set state ready
                } else {
                    dict append current_data abstract $textBehindTheTag
                }
            }
        }
    }
}

yahoosearch create searcher
searcher search "search text here"

for {set x 1} {$x <= 15} {incr x} {
    set result [searcher nextresult]
    dict with result {
        puts $title
        puts $url
        puts [textutil::adjust::indent [textutil::adjust::adjust $abstract] "  "]
        puts ""
    }
}
