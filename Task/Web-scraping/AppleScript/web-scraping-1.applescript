use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on firstDateonWebPage(URLText)
    set |⌘| to current application
    set pageURL to |⌘|'s class "NSURL"'s URLWithString:(URLText)
    -- Fetch the page HTML as data.
    -- The Xcode documentation advises against using dataWithContentsOfURL: over a network,
    -- but I'm guessing this applies to downloading large files rather than a Web page's HTML.
    -- If in doubt, the HTML can be fetched as text instead and converted to data in house.
    set HTMLData to |⌘|'s class "NSData"'s dataWithContentsOfURL:(pageURL)
    -- Or:
    (*
    set {HTMLText, encoding} to |⌘|'s class "NSString"'s stringWithContentsOfURL:(pageURL) ¬
        usedEncoding:(reference) |error|:(missing value)
    set HTMLData to HTMLText's dataUsingEncoding:(encoding)
    *)

    -- Extract the page's visible text from the HTML.
    set straightText to (|⌘|'s class "NSAttributedString"'s alloc()'s initWithHTML:(HTMLData) ¬
        documentAttributes:(missing value))'s |string|()

    -- Use an NSDataDetector to locate the first date in the text. (It's assumed here there'll be one.)
    set dateDetector to |⌘|'s class "NSDataDetector"'s dataDetectorWithTypes:(|⌘|'s NSTextCheckingTypeDate) ¬
        |error|:(missing value)
    set matchRange to dateDetector's rangeOfFirstMatchInString:(straightText) options:(0) ¬
        range:({0, straightText's |length|()})

    -- Return the date text found.
    return (straightText's substringWithRange:(matchRange)) as text
end firstDateonWebPage

firstDateonWebPage("https://www.rosettacode.org/wiki/Talk:Web_scraping")
