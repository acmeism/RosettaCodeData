USING: formatting fry io kernel locals math math.factorials
math.functions math.ranges random sequences ;

: (analytical) ( m n -- x )
    [ drop factorial ] [ ^ /f ] [ - factorial / ] 2tri ;

: analytical ( n -- x )
    dup [1,b] [ (analytical) ] with map-sum ;

: loop-length ( n -- x )
    [ 0 0 1 [ 2dup bitand zero? ] ] dip
    '[ [ 1 + ] 2dip bitor 1 _ random shift ] while 2drop ;

:: average-loop-length ( n #tests -- x )
     0 #tests [ n loop-length + ] times #tests / ;

: stats ( n -- avg exp )
    [ 1,000,000 average-loop-length ] [ analytical ] bi ;

: .line ( n -- )
    dup stats 2dup / 1 - 100 *
    "%2d %8.4f %8.4f %6.3f%%\n" printf ;

" n\tavg\texp.\tdiff\n-------------------------------" print
20 [1,b] [ .line ] each
