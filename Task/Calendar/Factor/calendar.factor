USING: arrays calendar.format grouping io.streams.string kernel
math.ranges prettyprint sequences sequences.interleaved ;
IN: rosetta-code.calendar

: calendar ( year -- )
    12 [1,b] [ 2array [ month. ] with-string-writer ] with map
    3 <groups> [ "   " <interleaved> ] map 5 " " <repetition>
    <interleaved> simple-table. ;

: calendar-demo ( -- ) 1969 calendar ;

MAIN: calendar-demo
