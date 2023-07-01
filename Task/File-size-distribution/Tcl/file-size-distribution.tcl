package require fileutil::traverse
namespace path {::tcl::mathfunc ::tcl::mathop}

# Ternary helper
proc ? {test a b} {tailcall if $test [list subst $a] [list subst $b]}

set dir [? {$argc} {[lindex $argv 0]} .]
fileutil::traverse Tobj $dir \
	-prefilter {apply {path {ne [file type $path] link}}} \
	-filter    {apply {path {eq [file type $path] file}}}
Tobj foreach path {
	set size [file size $path]
	dict incr hist [? {$size} {[int [log10 $size]]} -1]
}
Tobj destroy

foreach key [lsort -int [dict keys $hist]] {
	puts "[? {$key == -1} 0 {1e$key}]\t[dict get $hist $key]"
}
