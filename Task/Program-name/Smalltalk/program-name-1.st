"exec" "gst" "-f" "$0" "$0" "$@"
"exit"

| program |

program := Smalltalk getArgv: 1.

Transcript show: 'Program: ', program; cr.
