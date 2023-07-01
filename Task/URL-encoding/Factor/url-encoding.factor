USING: combinators.short-circuit unicode urls.encoding.private ;

: my-url-encode ( str -- encoded )
    [ { [ alpha? ] [ "-._~" member? ] } 1|| ] (url-encode) ;

"http://foo bar/" my-url-encode print
