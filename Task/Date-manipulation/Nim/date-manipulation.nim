import posix, times

var ts: Ttm
discard "March 7 2009 7:30pm EST".strptime("%B %d %Y %I:%M%p %Z", ts)
ts.tmHour += 12
echo ts.mktime
