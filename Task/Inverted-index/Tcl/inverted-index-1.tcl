package require Tcl 8.5
proc wordsInString str {
    # We define "words" to be "maximal sequences of 'word' characters".
    # The other possible definition is to use 'non-space' characters.
    regexp -all -inline {\w+} $str
}

# Adds a document to the index. The index is a map from words to a map
# from filenames to lists of word locations.
proc addDocumentToIndex {filename} {
    global index
    set f [open $filename]
    set data [read $f]
    close $f

    set i 0
    array set localidx {}
    foreach word [wordsInString $data] {
    lappend localidx($word) $i
    incr i
    }

    # Transcribe into global index
    foreach {word places} [array get localidx] {
    dict set index($word) $filename $places
    }
}

# How to use the index to find files containing a word
proc findFilesForWord {word} {
    global index
    if {[info exists index($word)]} {
    return [dict keys $index($word)]
    }
}
# How to use the index to find files containing all words from a list.
# Note that this does not use the locations within the file.
proc findFilesWithAllWords {words} {
    set files [findFilesForWord [lindex $words 0]]
    foreach w [lrange $words 1 end] {
    set wf [findFilesForWord $w]
    set newfiles {}
    foreach f $files {
        if {$f in $wf} {lappend newfiles $f}
    }
    set files $newfiles
    }
    return $files
}

# How to use the index to find a sequence of words in a file.
proc findFilesWithWordSequence {words} {
    global index
    set files {}
    foreach w $words {
    if {![info exist index($w)]} {
        return
    }
    }
    dict for {file places} $index([lindex $words 0]) {
    if {$file in $files} continue
    foreach start $places {
        set gotStart 1
        foreach w [lrange $words 1 end] {
        incr start
        set gotNext 0
        foreach {f ps} $index($w) {
            if {$f ne $file} continue
            foreach p $ps {
            if {$p == $start} {
                set gotNext 1
                break
            }
            }
            if {$gotNext} break
        }
        if {!$gotNext} {
            set gotStart 0
            break
        }
        }
        if {$gotStart} {
        lappend files $file
        break
        }
    }
    }
    return $files
}
