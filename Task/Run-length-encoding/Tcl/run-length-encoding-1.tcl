proc encode {string} {
    set encoding {}
    # use a regular expression to match runs of one character
    foreach {run -} [regexp -all -inline {(.)\1+|.} $string] {
        lappend encoding [string length $run] [string index $run 0]
    }
    return $encoding
}

proc decode {encoding} {
    foreach {count char} $encoding  {
        append decoded [string repeat $char $count]
    }
    return $decoded
}
