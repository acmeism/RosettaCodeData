USING: calendar calendar.format formatting fry io kernel math
sequences ;
IN: rosetta-code.five-weekends

: timestamps>my ( months -- )
   [ { MONTH bl YYYY nl } formatted 2drop ] each ;

: month-range ( start-year #months -- seq )
    '[ _ <year> _ <iota> ] call [ months time+ ] with map ;

: find-five-weekend-months ( months -- months' )
    [ [ friday? ] [ days-in-month ] bi 31 = and ] filter ;

1900 12 201 * month-range find-five-weekend-months
[ length "%d five-weekend months found.\n" printf ]
[ 5 head  timestamps>my "..." print               ]
[ 5 tail* timestamps>my                           ] tri
