FloatE nan
FloatD nan
FloatE infinity
FloatD infinity
FloatE negativeInfinity
FloatD negativeInfinity

Float zero -> 0.0
Float negativeZero -> -0.0
0.0 negated -> -0.0
0.0 negated = 0.0 -> true. "they have the same value"
0.0 negated < 0.0 -> false
0.0 negated > 0.0 -> false

1.0 isFinite -> true
FloatE infinity isFinite -> false

(FloatE infinity = FloatD infinity) -> true
FloatE infinity > 1e200 -> true
FloatE infinity > FloatE negativeInfinity -> true
FloatE infinity > Number negativeInfinity -> true
(FloatE infinity negated = FloatE negativeInfinity) -> true

(1.0 / 0.0) -> ZeroDivision exception
[ 1.0 / 0.0 ] on:ZeroDivide do:[:ex | ex proceed ] -> infinity

(0.0 / 0.0) -> ZeroDivision exception
[ 0.0 / 0.0 ] on:ZeroDivide do:[:ex | ex proceed ] -> nan

(1.0 / Float infinity) -> 0.0
(1.0 / Float negativeInfinity) -> -0.0

-4 sqrt -> ImaginaryResultError exception
Number trapImaginary:[ -4 sqrt ] -> (0+2.0i)  (works in Smalltalk/X)
[ -4 sqrt ] on:DomainError do:[:ex | ex proceed] -> nan

-1 log10 -> DomainError exception
[ -1 log10 ] on:DomainError do:[:ex | ex proceed] -> nan
