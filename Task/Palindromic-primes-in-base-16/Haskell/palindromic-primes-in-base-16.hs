import Data.List
import Data.Char (intToDigit)
primes = filterPrime [2..] where
  filterPrime (p:xs) =
    p : filterPrime [x | x <- xs, x `mod` p /= 0]

num2hex :: Int -> [Char]
num2hex = map dig2hex . reverse . unfoldr gen where
    gen 0 = Nothing
    gen x = Just (x `mod` 16, x `div` 16)

dig2hex :: Int -> Char
dig2hex a
    |a < 10 = intToDigit a
    |a == 10 = 'a'
    |a == 11 = 'b'
    |a == 12 = 'c'
    |a == 13 = 'd'
    |a == 14 = 'e'
    |a == 15 = 'f'

isPalindrome :: Eq a => [a] -> Bool
isPalindrome lis = lis == reverse lis

base16PaliPrimes = [
    hex |
    x <- takeWhile (<500) primes,
    let hex = num2hex x,
    isPalindrome hex]
