isNumeric=: _ ~: _ ". ]
isNumericScalar=: 1 -: isNumeric
TXT=: ,&' a scalar numeric value.' &.> ' is not';' represents'
sayIsNumericScalar=: , TXT {::~ isNumericScalar
