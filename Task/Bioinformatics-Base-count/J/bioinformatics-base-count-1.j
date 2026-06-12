countBases=: (({.;#)/.~)@,
totalBases=: #@,

require 'format/printf'

printSequence=: verb define
'Sequence:' printf ''
'%4d: %s' printf ((- {.)@(+/\)@:(#"1) ,.&<"_1 ]) y
'\n Base Count\n-----------' printf ''
'%5s: %4d' printf countBases y
'-----------\nTotal = %3d' printf totalBases y
)
