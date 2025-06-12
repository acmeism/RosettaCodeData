set term "calico"
set fd [open "cats.txt" "r"]
set contents [read $fd]
set lines [split $contents "\n"]

foreach line $lines {
    if { [lsearch $line $term] > 0 } {
       puts "found $term in \"$line\""
    }
}
