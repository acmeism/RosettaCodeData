set now to (current date)
set GMTOffset to (time to GMT)
copy now to epoch
tell epoch to set {its day, its month, its year, its time} to {1, January, 2001, 0}
set systemTime to now - GMTOffset - epoch

-- Format output:
set offsetStr to GMTOffset div hours * 100 + GMTOffset mod hours div minutes
if (GMTOffset < 0) then
    set offsetStr to " -" & text 3 thru -1 of ((-10000 + offsetStr) as text)
else
    set offsetStr to " +" & text 2 thru -1 of ((10000 + offsetStr) as text)
end if
return (now as text) & offsetStr & (linefeed & systemTime) & (" seconds since " & epoch & " UTC")
