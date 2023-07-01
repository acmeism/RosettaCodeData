package require Tk
pack [labelframe .files -text Files] -side left -fill y
pack [listbox .files.list -listvariable files]
pack [button .files.add -command AddFile -text "Add File to Index"]
pack [labelframe .found -text Found] -side right -fill y
pack [listbox .found.list -listvariable found] -fill x
pack [entry .found.entry -textvariable terms] -fill x
pack [button .found.findAll -command FindAll \
    -text "Find File with All"] -side left
pack [button .found.findSeq -command FindSeq \
    -text "Find File with Sequence"] -side right

# The actions invoked by various GUI buttons
proc AddFile {} {
    global files
    set f [tk_getOpenFile]
    if {$f ne ""} {
    addDocumentToIndex $f
    lappend files $f
    }
}
proc FindAll {} {
    global found terms
    set words [wordsInString $terms]
    set fs [findFilesWithAllWords $words]
    lappend found "Searching for files with all $terms" {*}$fs \
    "---------------------"
}
proc FindSeq {} {
    global found terms
    set words [wordsInString $terms]
    set fs [findFilesWithWordSequence $words]
    lappend found "Searching for files with \"$terms\"" {*}$fs \
    "---------------------"
}
