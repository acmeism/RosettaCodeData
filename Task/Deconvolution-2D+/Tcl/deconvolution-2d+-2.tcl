# A pretty-printer
proc pretty matrix {
    set size [rank $matrix]
    if {$size == 1} {
	return \[[join $matrix ", "]\]
    } elseif {$size == 2} {
	set out ""
	foreach row $matrix {
	    append out " " [pretty $row] ",\n"
	}
	return \[[string trimleft [string trimright $out ,\n]]\]
    }
    set rowout {}
    foreach row $matrix {append rowout [pretty $row] ,\n}
    set rowout2 {}
    foreach row [split [string trimright $rowout ,\n] \n] {
	append rowout2 "   " $row \n
    }
    return \[\n[string trimright $rowout2 \n]\n\]
}

# The 3D test data
set f {
    {{-9 5 -8} {3 5 1}}
    {{-1 -7 2} {-5 -6 6}}
    {{8 5 8} {-2 -6 -4}}
}
set g {
    {
	{54 42 53 -42 85 -72}
	{45 -170 94 -36 48 73}
	{-39 65 -112 -16 -78 -72}
	{6 -11 -6 62 49 8}}
    {
	{-57 49 -23 52 -135 66}
	{-23 127 -58 -5 -118 64}
	{87 -16 121 23 -41 -12}
	{-19 29 35 -148 -11 45}}
    {
	{-55 -147 -146 -31 55 60}
	{-88 -45 -28 46 -26 -144}
	{-12 -107 -34 150 249 66}
	{11 -15 -34 27 -78 -50}}
    {
	{56 67 108 4 2 -48}
	{58 67 89 32 32 -8}
	{-42 -31 -103 -30 -23 -8}
	{6 4 -26 -10 26 12}}
}

# Now do the deconvolution and print it out
puts h:\ [pretty [deconvolve $g $f]]
