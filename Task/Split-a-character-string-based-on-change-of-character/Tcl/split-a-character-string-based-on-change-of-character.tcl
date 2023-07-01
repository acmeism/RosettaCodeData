set string "gHHH5YY++///\\"

regsub -all {(.)\1*} $string {\0, } string
regsub {, $} $string {} string
puts $string
