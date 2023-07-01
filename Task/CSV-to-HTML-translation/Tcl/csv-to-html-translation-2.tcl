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

html::init {
    table.border 1
    table.summary "csv2html program output"
    tr.bgcolor orange
}

# Helpers; the html package is a little primitive otherwise
proc table {contents {opts ""}} {
    set out [html::openTag table $opts]
    append out [uplevel 1 [list subst $contents]]
    append out [html::closeTag]
}
proc tr {list {ropt ""}} {
    set out [html::openTag tr $ropt]
    foreach x $list {append out [html::cell "" $x td]}
    append out [html::closeTag]
}

# Parse the CSV data
struct::queue rows
foreach line [split $csvData "\n"] {
    csv::split2queue rows $line
}

# Generate the output
puts [subst {
    [table {
	[tr [html::quoteFormValue [rows get]] {bgcolor="yellow"}]
	[html::while {[rows size]} {
	    [tr [html::quoteFormValue [rows get]]]
	}]
    }]
}]
