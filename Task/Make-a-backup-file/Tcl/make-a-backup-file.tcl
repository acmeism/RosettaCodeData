package require Tcl 8.5

proc backupopen {filename mode} {
    set filename [file normalize $filename]
    if {[file exists $filename]} {
	set backups [glob -nocomplain -path $filename ,*]
	set backups [lsort -dictionary \
		[lsearch -all -inline -regexp $backups {,\d+$}]]
	if {![llength $backups]} {
	    set n 0
	} else {
	    set n [regexp -inline {\d+$} [lindex $backups end]]
	}
	while 1 {
	    set backup $filename,[incr n]
	    if {![catch {file copy $filename $backup}]} {
		break
	    }
	}
    }
    return [open $filename $mode]
}
