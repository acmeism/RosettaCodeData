package require http

# finally is a bit like go's defer
proc finally args {
    tailcall trace add variable :#finally#: unset [list apply [list args $args]]
}

# basic wrapper for http::geturl
proc geturl {url} {
    set tok [::http::geturl $url]
    finally ::http::cleanup $tok
    ::http::data $tok
}
proc maclookup {mac} {
    geturl http://api.macvendors.com/$mac
}

foreach mac {00-14-22-01-23-45 88:53:2E:67:07:BE} {
    puts "$mac\t[maclookup $mac]"
}
