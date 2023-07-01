# This syntax is pretty ugly, alas
set pipe [open |[list ls -l] "r"]
fconfigure $pipe -encoding iso8859-1 -translation lf
set data [read $pipe]
close $pipe
