-- Get the run of non-white-space at the end, if any.
try
    set output to (do shell script "echo 'I am a string' | egrep -o '\\S+$'")
on error message
    set output to "No match"
end try
-- Replace the first instance of "orig…" with "modified".
set moreOutput to(do shell script "echo 'I am the original string' | sed 's/orig[a-z]*/modified/'")
return output & linefeed & moreOutput
