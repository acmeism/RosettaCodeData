proc simplemultisplit {text sep} {
    set map {}; foreach s $sep {lappend map $s "\uffff"}
    return [split [string map $map $text] "\uffff"]
}
puts [simplemultisplit "a!===b=!=c" {"==" "!=" "="}]
