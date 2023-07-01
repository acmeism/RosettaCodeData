on isPalindrome(txt)
    set txt to join(txt, "") -- In case the input's a list (array).
    return (txt = join(reverse of txt's characters, ""))
end isPalindrome

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

return isPalindrome("Radar")
