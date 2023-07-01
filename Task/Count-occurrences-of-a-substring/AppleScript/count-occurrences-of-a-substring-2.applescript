on countSubstring(theString, theSubstring)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to theSubstring
    set substringCount to (count theString's text items) - 1
    set AppleScript's text item delimiters to astid

    return substringCount
end countSubstring

{countSubstring("the three truths", "th"), countSubstring("ababababab", "abab")}
