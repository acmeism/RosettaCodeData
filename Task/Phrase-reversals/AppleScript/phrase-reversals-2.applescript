set aString to "rosetta code phrase reversal"

set astid to AppleScript's text item delimiters

set AppleScript's text item delimiters to ""
set phrase1 to (reverse of characters of aString) as text

set AppleScript's text item delimiters to space
set phrase2 to (reverse of words of phrase1) as text

set phrase3 to (reverse of words of aString) as text

set AppleScript's text item delimiters to linefeed
set output to {phrase1, phrase2, phrase3} as text

set AppleScript's text item delimiters to astid

return output
