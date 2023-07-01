proc stripLineComments {inputString {commentChars ";#"}} {
    # Convert the character set into a transformation
    foreach c [split $commentChars ""] {lappend map $c "\uFFFF"}; # *very* rare character!
    # Apply transformation and then use a simpler constant RE to strip
    regsub -all -line {\uFFFF.*$} [string map $map $inputString] "" commentStripped
    # Now strip the whitespace
    regsub -all -line {^[ \t\r]*(.*\S)?[ \t\r]*$} $commentStripped {\1}
}
