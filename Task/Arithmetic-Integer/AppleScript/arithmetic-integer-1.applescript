set i1 to (text returned of (display dialog "Enter an integer value" default answer "")) as integer
set i2 to (text returned of (display dialog "Enter another integer value" default answer "")) as integer

set sum to i1 + i2
set diff to i1 - i2
set prod to i1 * i2
set quot to i1 div i2 -- Rounds towards zero.
set remainder to i1 mod i2 -- The result's sign matches the dividend's.
set exp to i1 ^ i2 -- The result's always a real.

return {|integers|:{i1, i2}, difference:diff, product:prod, quotient:quot, remainder:remainder, exponientiation:exp}
