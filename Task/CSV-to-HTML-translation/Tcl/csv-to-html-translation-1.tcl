package require Tcl 8.5
package require csv
package require html
package require struct::queue

set csvData "Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!"

struct::queue rows
foreach line [split $csvData "\n"] {
    csv::split2queue rows $line
}
html::init
puts [subst {
    [html::openTag table {summary="csv2html program output"}]
    [html::while {[rows size]} {
	[html::row {*}[html::quoteFormValue [rows get]]]
    }]
    [html::closeTag]
}]
