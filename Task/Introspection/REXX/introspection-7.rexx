if testxyz() then say 'function XYZ not found.'
             else say 'function XYZ was found.'
exit

testxyz: signal on syntax
y='XYZ'(123)
return 0

syntax: return 1
