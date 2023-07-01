set docsFolderPath to POSIX path of (path to documents folder)
-- By default, "ls" returns file names sorted by character code, so save the sorting until the end and do it case-insensitively.
set shellCommandText to "ls -f " & quoted form of docsFolderPath & " | grep -i '\\.pdf$' | sort -f"
return paragraphs of (do shell script shellCommandText)
--> EXAMPLE RESULT: {"About Stacks.pdf", "AppleScriptLanguageGuide.pdf", "Artistic Orchestration.pdf", "DiskWarrior Manual.pdf", "RFC 2445 (iCalendar spec).pdf", "RFC 4180 (CSV spec).pdf", "robinson_jeffers_2004_9.pdf", "ShellScripting.pdf"}
