USING: accessors calendar continuations http.client io kernel
sequences threads ;

: mac-vendor ( str -- str )
    "http://api.macvendors.com/" prepend
    [ http-get nip ] [ nip response>> message>> ] recover ;

"FC-A1-3E"
"FC:FB:FB:01:FA:21"
"10-11-22-33-44-55-66"
[ mac-vendor print 1 seconds sleep ] tri@
