reverseString("Hello World!")

on reverseString(str)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set reversedString to reverse of characters of str as text
    set AppleScript's text item delimiters to astid
    return reversedString
end reverseString
