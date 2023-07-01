import Data.List
import Data.Char
import Data.String.Utils
import Data.List.Utils
import Data.Function (on)


printOutput = do
                putStrLn "# Ignoring leading spaces \n"
                printBlockOfMessages sample1Rule ignoringStartEndSpaces
                putStrLn "\n # Ignoring multiple adjacent spaces (m.a.s) \n"
                printBlockOfMessages sample2Rule ignoringMultipleAdjacentSpaces
                putStrLn "\n # Equivalent whitespace characters \n"
                printBlockOfMessages sample3Rule ignoringMultipleAdjacentSpaces
                putStrLn "\n # Case Indepenent sorts \n"
                printBlockOfMessages sample4Rule caseIndependent
                putStrLn "\n # Numeric fields as numerics \n"
                printBlockOfMessages sample5Rule numericFieldsAsNumbers
                putStrLn "\n # Title sorts \n"
                printBlockOfMessages sample6Rule removeLeadCommonWords

printMessage message content = do
                 putStrLn message
                 mapM_ print content

printBlockOfMessages list function = do
      printMessage "Text strings:" list
      printMessage "Normally sorted:" (sort list)
      printMessage "Naturally sorted:" (sortListWith list function)


-- samples
sample1Rule = ["ignore leading spaces: 2-2", " ignore leading spaces: 2-1", "  ignore leading spaces: 2+0",  "   ignore leading spaces: 2+1"]
sample2Rule = ["ignore m.a.s spaces: 2-2", "ignore m.a.s  spaces: 2-1", "ignore m.a.s   spaces: 2+0", "ignore m.a.s    spaces: 2+1"]
sample3Rule = ["Equiv. spaces: 3-3", "Equiv.\rspaces: 3-2", "Equiv.\x0cspaces: 3-1", "Equiv.\x0bspaces: 3+0", "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2"]
sample4Rule = ["cASE INDEPENENT: 3-2", "caSE INDEPENENT: 3-1", "casE INDEPENENT: 3+0", "case INDEPENENT: 3+1"]
sample5Rule = ["foo100bar99baz0.txt", "foo100bar10baz0.txt", "foo1000bar99baz10.txt", "foo1000bar99baz9.txt"]
sample6Rule = ["The Wind in the Willows", "The 40th step more", "The 39 steps", "Wanda"]


-- function to execute all sorts
sortListWith l f = sort $ f l

-- 1. Ignore leading, trailing and multiple adjacent spaces

 -- Ignoring leading spaces

-- receive a String and remove all spaces from the start and end of that String, a String is considered an List os Char
-- ex: "  a string " = "a string"
ignoringStartEndSpaces :: [String] -> [String]
ignoringStartEndSpaces = map strip

-- Ignoring multiple adjacent spaces and Equivalent whitespace characters

ignoringMultipleAdjacentSpaces :: [String] -> [String]
ignoringMultipleAdjacentSpaces = map (unwords . words)

-- 2. Equivalent whitespace characters
-- 3. Case independent sort
-- lower case of an entire String
-- ex "SomeCAse" = "somecase"
caseIndependent :: [String] -> [String]
caseIndependent = map (map toLower)

-- 4. Numeric fields as numerics (deals with up to 20 digits)
numericFieldsAsNumbers :: [String] -> [[Int]]
numericFieldsAsNumbers = map findOnlyNumerics

findOnlyNumerics :: String -> [Int]
findOnlyNumerics s = convertDigitAsStringToInt $ makeListOfDigitsAsString $ extractDigitsAsString s
extractDigitsAsString :: String -> [String]
extractDigitsAsString s = map (filter isNumber) $ groupBy ((==) `on` isNumber ) s
makeListOfDigitsAsString :: [String] -> [String]
makeListOfDigitsAsString l = tail $ nub l
convertDigitAsStringToInt :: [String] -> [Int]
convertDigitAsStringToInt = map (joiner . map  digitToInt)

-- join a list of numbers into a single number
-- ex [4,2] = 42
joiner :: [Int] -> Int
joiner = read . concatMap show

-- 5. Title sort
removeLeadCommonWords l = map removeLeadCommonWord $ splitList l

splitList = map words
removeLeadCommonWord a = unwords $ if f a commonWords then tail a else a
                        where f l1 = elem (map toLower (head l1))
                              commonWords = ["the","a","an","of"]
