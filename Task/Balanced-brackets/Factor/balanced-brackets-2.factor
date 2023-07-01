USING: io formatting locals kernel math sequences unicode.case ;
IN: balanced-brackets

: map-braces ( -- qout )
  [
    {
      { "[" [ drop  1 ] }
      { "]" [ drop -1 ] }
            [ drop  0 ]
    } case
  ]
;

: balanced? ( str -- ? )
  map-braces map sum 0 =
;

"[1+2*[3+4*[5+6]-3]*4-[3*[3+3]]]" balanced?
-- Data stack:
t
