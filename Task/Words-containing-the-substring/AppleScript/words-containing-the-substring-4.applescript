use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on wordsContaining(textFile, searchText, minLength)
    set theText to current application's class "NSMutableString"'s ¬
        stringWithContentsOfFile:(textFile's POSIX path) usedEncoding:(missing value) |error|:(missing value)
    -- Replace every run of non AppleScript 'word' characters with a linefeed.
    tell theText to replaceOccurrencesOfString:("(?:[\\W--[.'’]]|(?<!\\w)[.'’]|[.'’](?!\\w))++") withString:(linefeed) ¬
        options:(current application's NSRegularExpressionSearch) range:({0, its |length|()})
    -- Split the text at the linefeeds.
    set theWords to theText's componentsSeparatedByString:(linefeed)
    -- Filter the resulting array for strings which meet the search text and minimum length requirements,
    -- matching AppleScript's current case-sensitivity setting. NSString lengths are measured in 16-bit
    -- code units so use regex to check the lengths in characters.
    if ("A" = "a") then
        set filterTemplate to "((self CONTAINS[c] %@) && (self MATCHES %@))"
    else
        set filterTemplate to "((self CONTAINS %@) && (self MATCHES %@))"
    end if
    set filter to current application's class "NSPredicate"'s ¬
        predicateWithFormat_(filterTemplate, searchText, ".{" & minLength & ",}+")

    return (theWords's filteredArrayUsingPredicate:(filter)) as list
end wordsContaining
