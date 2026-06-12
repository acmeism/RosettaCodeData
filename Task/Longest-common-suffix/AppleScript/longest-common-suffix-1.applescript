use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on longestCommonSuffix(textList)
    -- Eliminate any non-texts from the input.
    if (textList's class is record) then return ""
    set textList to (textList as list)'s text
    if (textList is {}) then return ""

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    repeat with i from 1 to (count textList)
        set item i of textList to (reverse of characters of item i of textList) as text
    end repeat
    set lcs to (reverse of characters of longestCommonPrefix(textList)) as text
    set AppleScript's text item delimiters to astid

    return lcs
end longestCommonSuffix

on longestCommonPrefix(textList)
    -- Eliminate any non-texts from the input.
    if (textList's class is record) then return ""
    set textList to (textList as list)'s text
    if (textList is {}) then return ""

    -- Convert the AppleScript list to an NSArray of NSStrings.
    set stringArray to current application's class "NSArray"'s arrayWithArray:(textList)

    -- Compare the strings case-insensitively using a built-in NSString method.
    set lcp to stringArray's firstObject()
    repeat with i from 2 to (count stringArray)
        set lcp to (lcp's commonPrefixWithString:(item i of stringArray) options:(current application's NSCaseInsensitiveSearch))
        if (lcp's |length|() is 0) then exit repeat
    end repeat

    -- Return the NSString result as AppleScript text.
    return lcp as text
end longestCommonPrefix

-- Tests and results:
longestCommonSuffix({"throne", "sousaphone"}) --> "one"
longestCommonSuffix({"prefix", "suffix"}) --> "fix"
longestCommonSuffix({"remark", "spark", "aardvark"}) --> "ark"
longestCommonSuffix({"ectoplasm", "banana"}) --> ""
