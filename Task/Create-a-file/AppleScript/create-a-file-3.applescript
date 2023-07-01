tell application "Finder" to set wd to target of window 1 as string
close (open for access wd & "output.txt")
