import Test.QuickCheck (generate, elements)

x <- (generate . elements) [1, 2, 3]
