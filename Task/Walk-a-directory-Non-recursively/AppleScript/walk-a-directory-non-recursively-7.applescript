use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

set docsFolderURL to current application's class "NSURL"'s fileURLWithPath:(POSIX path of (path to documents folder))
-- Get NSURLs for the folder's visible contents.
tell current application's class "NSFileManager"'s defaultManager() to ¬
    set visibleItems to its contentsOfDirectoryAtURL:(docsFolderURL) includingPropertiesForKeys:({}) ¬
        options:(current application's NSDirectoryEnumerationSkipsHiddenFiles) |error|:(missing value)
-- Filter case-insensitively for those whose names have ".pdf" extensions.
set filter to current application's class "NSPredicate"'s predicateWithFormat:("pathExtension ==[c] 'pdf'")
set PDFs to visibleItems's filteredArrayUsingPredicate:(filter)
-- Get the names of any matching items.
set pdfNames to PDFs's valueForKey:("lastPathComponent")
-- Sort these case-insensitively and considering numerics.
set pdfNames to pdfNames's sortedArrayUsingSelector:("localizedStandardCompare:")
-- Return the result as an AppleScript list of text.
return pdfNames as list
--> EXAMPLE RESULT: {"About Stacks.pdf", "AppleScriptLanguageGuide.pdf", "Artistic Orchestration.pdf", "DiskWarrior Manual.pdf", "RFC 2445 (iCalendar spec).pdf", "RFC 4180 (CSV spec).pdf", "robinson_jeffers_2004_9.pdf", "ShellScripting.pdf"}
