import Data.List (isInfixOf)
import Numeric (showHex)
import Data.Char (isDigit)

data IPChunk = IPv6Chunk String | IPv4Chunk (String, String) |
    IPv6WithPort [IPChunk] String | IPv6NoPort [IPChunk] |
    IPv4WithPort IPChunk String | IPv4NoPort IPChunk |
    IPInvalid | IPZeroSection | IPUndefinedWithPort String |
    IPUndefinedNoPort

instance Show IPChunk where
    show (IPv6Chunk a) = a
    show (IPv4Chunk (a,b)) = a ++ b
    show (IPv6WithPort a p) = "IPv6 " ++ concatMap show a ++ " port " ++ p
    show (IPv6NoPort a) = "IPv6 " ++ concatMap show a ++ " no port"
    show (IPv4WithPort a p) = "IPv4 " ++ show a ++ " port " ++ p
    show (IPv4NoPort a) = "IPv4 " ++ show a
    show IPInvalid = "Invalid IP address"

isIPInvalid IPInvalid = True
isIPInvalid _ = False

isIPZeroSection IPZeroSection = True
isIPZeroSection _ = False

splitOn _ [] = []
splitOn x xs = let (a, b) = break (== x) xs in a : splitOn x (drop 1 b)

count x = length . filter (== x)

between a b x = x >= a && x <= b

none f = all (not . f)

parse1 [] = IPInvalid
parse1 "::" = IPUndefinedNoPort
parse1 ('[':':':':':']':':':ps) = if portIsValid ps then IPUndefinedWithPort ps else IPInvalid
parse1 ('[':xs) = if "]:" `isInfixOf` xs
    then let (a, b) = break (== ']') xs in
            if tail b == ":" then IPInvalid else IPv6WithPort (map chunk (splitOn ':' a)) (drop 2 b)
    else IPInvalid
parse1 xs
    | count ':' xs <= 1 && count '.' xs == 3 =
        let (a, b) = break (== ':') xs in case b of
                "" -> IPv4NoPort (chunk a)
                (':':ps) -> IPv4WithPort (chunk a) ps
                _ -> IPInvalid
    | count ':' xs > 1 && count '.' xs <= 3 =
        IPv6NoPort (map chunk (splitOn ':' xs))

chunk [] = IPZeroSection
chunk xs
    | '.' `elem` xs = case splitOn '.' xs of
        [a,b,c,d] -> let [e,f,g,h] = map read [a,b,c,d]
                     in if all (between 0 255) [e,f,g,h]
                            then let [i,j,k,l] = map (\n -> fill 2 $ showHex n "") [e,f,g,h]
                                 in IPv4Chunk (i ++ j, k ++ l)
                            else IPInvalid
    | ':' `notElem` xs && between 1 4 (length xs) && all (`elem` "0123456789abcdef") xs = IPv6Chunk (fill 4 xs)
    | otherwise = IPInvalid

fill n xs = replicate (n - length xs) '0' ++ xs

parse2 IPInvalid = IPInvalid
parse2 (IPUndefinedWithPort p) = IPv6WithPort (replicate 8 zeroChunk) p
parse2 IPUndefinedNoPort = IPv6NoPort (replicate 8 zeroChunk)
parse2 a = case a of
    IPv6WithPort xs p -> if none isIPInvalid xs && portIsValid p
        then let ys = complete xs
             in  if countChunks ys == 8
                     then IPv6WithPort ys p
                     else IPInvalid
        else IPInvalid
    IPv6NoPort xs -> if none isIPInvalid xs
        then let ys = complete xs
             in  if countChunks ys == 8
                     then IPv6NoPort ys
                     else IPInvalid
        else IPInvalid
    IPv4WithPort (IPv4Chunk a) p -> if portIsValid p
        then IPv4WithPort (IPv4Chunk a) p
        else IPInvalid
    IPv4NoPort (IPv4Chunk a) -> IPv4NoPort (IPv4Chunk a)
    _ -> IPInvalid

zeroChunk = IPv6Chunk "0000"

portIsValid a = all isDigit a && between 0 65535 (read a)

complete xs = case break isIPZeroSection xs of
    (_, [IPZeroSection]) -> []
    (ys, []) -> ys
    ([], (IPZeroSection:IPZeroSection:ys)) -> if any isIPZeroSection ys || countChunks ys > 7
        then []
        else replicate (8 - countChunks ys) zeroChunk ++ ys
    (ys, (IPZeroSection:zs)) -> if any isIPZeroSection zs || countChunks ys + countChunks zs > 7
        then []
        else ys ++ replicate (8 - countChunks ys - countChunks zs) zeroChunk ++ zs
    _ -> []

countChunks xs = foldl f 0 xs
    where f n (IPv4Chunk _) = n + 2
          f n (IPv6Chunk _) = n + 1

ip = parse2 . parse1

main = mapM_ (putStrLn . show . ip)
    ["127.0.0.1",                                  -- loop back
     "127.0.0.1:80",                               -- loop back +port
     "::1",                                        -- loop back
     "[::1]:80",                                   -- loop back +port
     "2605:2700:0:3::4713:93e3",                   -- Rosetta Code
     "[2605:2700:0:3::4713:93e3]:80"]              -- Rosetta Code
