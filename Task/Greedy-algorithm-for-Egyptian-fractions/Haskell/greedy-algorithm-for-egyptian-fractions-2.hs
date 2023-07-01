λ> :m Test.QuickCheck
λ> quickCheck (\n -> n == (sum $ egyptianFraction n))
+++ OK, passed 100 tests.
