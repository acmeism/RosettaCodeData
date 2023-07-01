USING: calendar calendar.english calendar.format calendar.parser
combinators io kernel math math.parser sequences splitting
unicode ;
IN: rosetta-code.date-manipulation

! e.g. "7:30pm" -> 19 30
: parse-hm ( str -- hours minutes )
    ":" split first2 [ digit? ] partition
    [ [ string>number ] bi@ ] dip "pm" = [ [ 12 + ] dip ] when ;

! Parse a date in the format "March 7 2009 7:30pm EST"
: parse-date ( str -- timestamp )
    " " split {
        [ first month-names index 1 + ]
        [ second string>number ]
        [ third string>number -rot ]
        [ fourth parse-hm 0 ]
        [ last parse-rfc822-gmt-offset ]
    } cleave <timestamp> ;

"March 7 2009 7:30pm EST" parse-date dup 12 hours time+
[ timestamp>rfc822 print ] bi@
