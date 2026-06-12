"exec" "gst" "-f" "$0" "$0" "$@"
"exit"

"
PackageLoader fileInPackage: 'ScriptedMain'.

Transcript show: 'Test: The meaning of life is ', ((ScriptedMain meaningOfLife) printString); cr.
