USING: combinators formatting generalizations io kernel math
math.extras math.functions.integer-logs math.order math.ranges
sequences strings tools.memory.private ;

: next ( m -- n )
    dup odd? [ dup dup * * ] when integer-sqrt ;

: new-max ( l i h a -- l i h a )
    [ drop dup ] 2dip nip dup ;

: (step) ( l i h a -- l i h a )
    [ 1 + ] 3dip 2dup < [ new-max ] when next ;

: step ( l i h a -- l i h a )
    dup 1 = [ (step) ] unless ;

: juggler ( n quot: ( h -- obj ) -- l i h )
    [ 0 0 ] [ dup [ step ] to-fixed-point drop ] [ call ] tri*
    [ 1 [-] ] dip ; inline

CONSTANT: fmt "%-8s %-8s %-8s %s\n"

: row. ( n quot -- )
    dupd juggler [ commas ] 4 napply fmt printf ; inline

: dashes. ( n -- )
    CHAR: - <string> print ;

: header. ( str -- )
    [ "n" "l[n]" "i[n]" ] dip fmt printf 45 dashes. ;

: juggler. ( seq quot str -- )
    header. [ row. ] curry each ; inline

20 39 [a,b] [ ] "h[n]" juggler. nl

{ 113 173 193 2183 11229 15065 15845 30817 }
[ integer-log10 1 + ] "d[n]" juggler.
