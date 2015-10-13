gifts :: [String]
gifts = [
    "And a partridge in a pear tree!",
    "Two turtle doves,",
    "Three french hens,",
    "Four calling birds,",
    "FIVE GOLDEN RINGS,",
    "Six geese a-laying,",
    "Seven swans a-swimming,",
    "Eight maids a-milking,",
    "Nine ladies dancing,",
    "Ten lords a-leaping,",
    "Eleven pipers piping,",
    "Twelve drummers drumming," ]

days :: [String]
days = [
    "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth",
    "ninth", "tenth", "eleventh", "twelfth" ]

verseOfTheDay :: Int -> IO ()
verseOfTheDay day = do
    putStrLn $ "On the " ++ days !! day ++ " day of Christmas my true love gave to me... "
    mapM_ putStrLn [dayGift day d | d <- [day, day-1..0]]
    putStrLn ""
    where dayGift 0 _ = "A partridge in a pear tree!"
          dayGift _ gift = gifts !! gift

main :: IO ()
main = mapM_ verseOfTheDay [0..11]
