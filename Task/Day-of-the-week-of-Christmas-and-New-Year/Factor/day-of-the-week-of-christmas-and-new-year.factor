USING: calendar calendar.english calendar.holidays.us formatting
kernel sequences ;

CONSTANT: msg
    "In %d, New Years is on a %s, and Christmas is on a %s.\n"

: day-name ( ts -- str ) day-of-week day-names nth ;
: christmas ( n -- str ) christmas-day day-name ;
: new-years ( n -- str ) new-years-day day-name ;
: holidays ( n -- ny ch ) [ new-years ] [ christmas ] bi ;
: .holidays ( seq -- ) [ dup holidays msg printf ] each ;

{ 1578 1590 1642 1957 2020 2021 2022 2242 2245 2393 } .holidays
