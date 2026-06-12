package require Tcl 8.6

# This is identical to the address task. Skip forward to the next section...
proc split_DE_NL_address {streetAddress} {
    set RE {(?x)
	^ (.*?) (
	    (?:\s \d+ [-/] \d+)
	|
	    (?:\s (?!1940|1945)\d+ [a-zI. /]* \d*)
	)? $
    }
    regexp $RE $streetAddress -> str num
    return [list [string trim $str] [string trim $num]]
}

set data {
    Plataanstraat 5
    Straat 12
    Straat 12 II
    Dr. J. Straat   12
    Dr. J. Straat 12 a
    Dr. J. Straat 12-14
    Laan 1940 – 1945 37
    Plein 1940 2
    1213-laan 11
    16 april 1944 Pad 1
    1e Kruisweg 36
    Laan 1940-’45 66
    Laan ’40-’45
    Langeloërduinen 3 46
    Marienwaerdt 2e Dreef 2
    Provincialeweg N205 1
    Rivium 2e Straat 59.
    Nieuwe gracht 20rd
    Nieuwe gracht 20rd 2
    Nieuwe gracht 20zw /2
    Nieuwe gracht 20zw/3
    Nieuwe gracht 20 zw/4
    Bahnhofstr. 4
    Wertstr. 10
    Lindenhof 1
    Nordesch 20
    Weilstr. 6
    Harthauer Weg 2
    Mainaustr. 49
    August-Horch-Str. 3
    Marktplatz 31
    Schmidener Weg 3
    Karl-Weysser-Str. 6
}

# Construct the HTML to show
set html "<html><head><meta charset=\"UTF-8\">
<title>split_DE_NL_address</title></head><body>
<table border><tr><th>Address</th><th>Street</th><th>Number</th></tr>"
foreach streetAddress [split $data "\n"] {
    set streetAddress [string trim $streetAddress]
    if {$streetAddress eq ""} continue
    lassign [split_DE_NL_address $streetAddress] str num
    append html "<tr><td>$streetAddress</td><td>$str</td><td>$num</td></tr>"
}
append html "</table>
</body></html>"
# Pick a unique filename with .html extension (important!)
set f [file tempfile filename street.html]
fconfigure $f -encoding utf-8
puts $f $html
close $f

##### THE WEB BROWSER LAUNCH CODE MAGIC #####
# Relies on the default registration of browsers for .html files
# This is all very platform specific; Android requires another incantation again
if {$tcl_platform(platform) eq "windows"} {
    exec {*}[auto_execok start] "" [file nativename $filename]
} elseif {$tcl_platform(os) eq "Darwin"} {
    exec open $filename
} else {
    exec xdg_open $filename
}
