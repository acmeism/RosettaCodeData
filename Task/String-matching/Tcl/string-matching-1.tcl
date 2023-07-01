set isPrefix    [string equal -length [string length $needle] $haystack $needle]
set isContained [expr {[string first $needle $haystack] >= 0}]
set isSuffix    [string equal $needle [string range $haystack end-[expr {[string length $needle]-1}] end]]
