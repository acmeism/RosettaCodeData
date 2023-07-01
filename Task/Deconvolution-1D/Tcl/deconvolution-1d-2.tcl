# Simple pretty-printer
proc pp {name nlist} {
    set sep ""
    puts -nonewline "$name = \["
    foreach n $nlist {
	puts -nonewline [format %s%g $sep $n]
	set sep ,
    }
    puts "\]"
}

set h {-8 -9 -3 -1 -6 7}
set f {-3 -6 -1 8 -6 3 -1 -9 -9 3 -2 5 2 -2 -7 -1}
set g {24 75 71 -34 3 22 -45 23 245 25 52 25 -67 -96 96 31 55 36 29 -43 -7}

pp "deconv(g,f) = h" [1D deconvolve $g $f]
pp "deconv(g,h) = f" [1D deconvolve $g $h]
pp "  conv(f,h) = g" [1D convolve $f $h]
