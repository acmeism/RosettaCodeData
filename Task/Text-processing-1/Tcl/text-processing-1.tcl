set max_invalid_run 0
set max_invalid_run_end ""
set tot_file 0
set num_file 0

set linefmt "Line: %11s  Reject: %2d  Accept: %2d  Line_tot: %10.3f  Line_avg: %10.3f"

set filename readings.txt
set fh [open $filename]
while {[gets $fh line] != -1} {
    set tot_line [set count [set num_line 0]]
    set fields [regexp -all -inline {\S+} $line]
    set date [lindex $fields 0]
    foreach {val flag} [lrange $fields 1 end] {
        incr count
        if {$flag > 0} {
            incr num_line
            incr num_file
            set tot_line [expr {$tot_line + $val}]
            set invalid_run_count 0
        } else {
            incr invalid_run_count
            if {$invalid_run_count > $max_invalid_run} {
                set max_invalid_run $invalid_run_count
                set max_invalid_run_end $date
            }
        }
    }
    set tot_file [expr {$tot_file + $tot_line}]
    puts [format $linefmt $date [expr {$count - $num_line}] $num_line $tot_line \
                 [expr {$num_line > 0 ? $tot_line / $num_line : 0}]]
}
close $fh

puts ""
puts "File(s)  = $filename"
puts "Total    = [format %.3f $tot_file]"
puts "Readings = $num_file"
puts "Average  = [format %.3f [expr {$tot_file / $num_file}]]"
puts ""
puts "Maximum run(s) of $max_invalid_run consecutive false readings ends at $max_invalid_run_end"
