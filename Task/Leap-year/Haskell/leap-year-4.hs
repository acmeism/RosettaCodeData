import Test.HUnit

isLeapYear::Int->Bool
isLeapYear y
  | mod y 400 == 0 = True
  | mod y 100 == 0 = False
  | mod y 4 == 0 = True
  | otherwise = False

tests = TestList[TestCase $ assertEqual "4 is a leap year" True $ isLeapYear 4
                ,TestCase $ assertEqual "1 is not a leap year" False $ isLeapYear 1
                ,TestCase $ assertEqual "64 is a leap year" True $ isLeapYear 64
                ,TestCase $ assertEqual "2000 is a leap year" True $ isLeapYear 2000
                ,TestCase $ assertEqual "1900 is not a leap year" False $ isLeapYear 1900]
