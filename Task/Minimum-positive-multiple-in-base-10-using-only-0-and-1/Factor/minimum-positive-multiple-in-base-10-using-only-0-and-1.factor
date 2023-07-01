: is-1-or-0 ( char -- ? ) dup CHAR: 0 = [ drop t ] [ CHAR: 1 = ] if ;
: int-is-B10 ( n -- ? ) unparse [ is-1-or-0 ] all? ;
: B10-step ( x x -- x x ? ) dup int-is-B10 [ f ] [ over + t ] if ;
: find-B10 ( x -- x ) dup [ B10-step ] loop nip ;
