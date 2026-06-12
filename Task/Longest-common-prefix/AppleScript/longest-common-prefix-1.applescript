use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

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

--- Tests:
longestCommonPrefix({"interspecies", "interstellar", "interstate"}) --> "inters"
longestCommonPrefix({"throne", "throne"}) --> "throne"
longestCommonPrefix({"throne", "dungeon"}) --> ""
longestCommonPrefix({"throne", "", "throne"}) --> ""
longestCommonPrefix({""}) --> ""
longestCommonPrefix({}) --> ""
longestCommonPrefix({"prefix", "suffix"}) --> ""
longestCommonPrefix({"foo", "foobar"}) --> "foo"
