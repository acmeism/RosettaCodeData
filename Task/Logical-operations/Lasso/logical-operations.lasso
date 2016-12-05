// br is just for formatting output here
define br => '\r'

// define vars
local(a = true, b = false)

// boolean comparators.
// note, not including comparison operators which would return boolean results
'a AND b: ' + (#a && #b)
br
'a OR b: ' + (#a || #b)
br
'NOT a: ' + !#a
br
'NOT a (using not): ' + not #a
