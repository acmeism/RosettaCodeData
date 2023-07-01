-- The Name Game, Ethan Riley, 22nd May 2018
import Data.Char

isVowel :: Char -> Bool
isVowel c
    | char == 'A' = True
    | char == 'E' = True
    | char == 'I' = True
    | char == 'O' = True
    | char == 'U' = True
    | otherwise = False
    where char = toUpper c

isSpecial :: Char -> Bool
isSpecial c
    | char == 'B' = True
    | char == 'F' = True
    | char == 'M' = True
    | otherwise = False
    where char = toUpper c

shorten :: String -> String
shorten name
    | isVowel $ head name = map toLower name
    | otherwise = map toLower $ tail name

line :: String -> Char -> String -> String
line prefix letter name
    | letter == char = prefix ++ shorten name ++ "\n"
    | otherwise = prefix ++ letter:[] ++ shorten name ++ "\n"
    where char = toLower $ head name

theNameGame :: String -> String
theNameGame name =
    line (name ++ ", " ++ name ++ ", bo-") 'b' name ++
    line "Banana-fana fo-" 'f' name ++
    line "Fee-fi-mo-" 'm' name ++
    name ++ "!\n"

main =
    mapM_ (putStrLn . theNameGame) ["Gary", "Earl", "Billy", "Felix", "Mike", "Steve"]
