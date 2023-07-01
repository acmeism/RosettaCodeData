package require struct::matrix
package require csv

proc addSumColumn {filename {title "SUM"}} {
    set m [struct::matrix]

    # Load the CSV in
    set f [open $filename]
    csv::read2matrix $f $m "," auto
    close $f

    # Add the column with the sums
    set sumcol [$m columns]
    $m add column $title
    for {set i 1} {$i < [$m rows]} {incr i} {
	# Fill out a dummy value
	$m set cell $sumcol $i 0
	$m set cell $sumcol $i [tcl::mathop::+ {*}[$m get row $i]]
    }

    # Write the CSV out
    set f [open $filename w]
    csv::writematrix $m $f
    close $f

    $m destroy
}

addSumColumn "example.csv"
