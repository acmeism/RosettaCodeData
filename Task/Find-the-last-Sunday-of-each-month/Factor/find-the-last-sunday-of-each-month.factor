USING: calendar calendar.format command-line io kernel math math.parser
sequences ;
IN: rosetta-code.last-sunday

: parse-year     ( -- ts )     (command-line) second string>number <year> ;
: print-last-sun ( ts -- )     last-sunday-of-month (timestamp>ymd) nl ;
: inc-month      ( ts -- ts' ) 1 months time+ ;
: process-month  ( ts -- ts' ) dup print-last-sun inc-month ;
: main           ( -- )        parse-year 12 [ process-month ] times drop ;

MAIN: main
