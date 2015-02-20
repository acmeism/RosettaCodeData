set in [open "input.txt" r]
set out [open "output.txt" w]
fcopy $in $out
close $in
close $out
