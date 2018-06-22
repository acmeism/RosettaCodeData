USING: calendar calendar.format command-line io kernel math.parser sequences ;
IN: rosetta-code.last-fridays

(command-line) second string>number <year> 12 iota
[ months time+ last-friday-of-month ] with map
[ timestamp>ymd print ] each
