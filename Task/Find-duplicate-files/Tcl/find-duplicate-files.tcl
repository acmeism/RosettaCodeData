package require fileutil
package require md5

proc finddupfiles {dir {minsize 1}} {
    foreach fn [fileutil::find $dir] {
    file lstat $fn stat
    if {$stat(size) < $minsize} continue
    dict lappend byino $stat(dev),$stat(ino) $fn
    if {$stat(type) ne "file"} continue
    set f [open $fn "rb"]
    set content [read $f]
    close $f
    set md5 [md5::md5 -hex $content]
    dict lappend byhash $md5 $fn
    }
    set groups {}
    foreach group [dict values $byino] {
    if {[llength $group] <= 1} continue
    set gs [lsort $group]
    dict set groups [lindex $gs 0] $gs
    }
    foreach group [dict values $byhash] {
    if {[llength $group] <= 1} continue
    foreach f $group {
        if {[dict exists $groups $f]} {
        dict set groups $f [lsort -unique \
            [concat [dict get $groups $f] $group]]
        unset group
        break
        }
    }
    if {[info exist group]} {
        set gs [lsort $group]
        dict set groups [lindex $gs 0] $gs
    }
    }
    set masters {}
    dict for {n g} $groups {
    lappend masters [list $n [llength $g],$n]
    }
    set result {}
    foreach p [lsort -decreasing -index 1 -dictionary $masters] {
    set n [lindex $p 0]
    lappend result $n [dict get $groups $n]
    }
    return $result
}

foreach {leader dupes} [finddupfiles {*}$argv] {
    puts "$leader has duplicates"
    set n 0
    foreach d $dupes {
    if {$d ne $leader} {
        puts "   dupe #[incr n]: $d"
    }
    }
}
