set graphemeText to "🧑 👨 🧔 👨‍👩‍👦"
set output to {}
repeat with redactionTarget in {"👨", "👨‍👩‍👦"}
    set end of output to "Redact " & redactionTarget & ":"
    set end of output to "[w]: " & redact(graphemeText, redactionTarget, "[w]")
    set end of output to ""
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
