module RSAMaker
   where
import Data.Char ( chr )

encode :: String -> [Integer]
encode s = map (toInteger . fromEnum ) s

rsa_encode :: Integer -> Integer -> [Integer] -> [Integer]
rsa_encode n e numbers = map (\num -> mod ( num ^ e ) n ) numbers

rsa_decode :: Integer -> Integer -> [Integer] -> [Integer]
rsa_decode d n ciphers = map (\c -> mod ( c ^ d ) n ) ciphers

decode :: [Integer] -> String
decode encoded = map ( chr . fromInteger ) encoded

divisors :: Integer -> [Integer]
divisors n = [m | m <- [1..n] , mod n m == 0 ]

isPrime :: Integer -> Bool
isPrime n = divisors n == [1,n]

totient :: Integer -> Integer -> Integer
totient prime1 prime2 = (prime1 - 1 ) * ( prime2 - 1 )

myE :: Integer -> Integer
myE tot = head [n | n <- [2..tot - 1] , gcd n tot == 1]

myD :: Integer -> Integer -> Integer  -> Integer
myD e n phi = head [d | d <- [1..n] , mod ( d * e ) phi == 1]

main = do
   putStrLn "Enter a test text!"
   text <- getLine
   let primes = take 90 $ filter isPrime [1..]
       p1     = last primes
       p2     = last $ init primes
       tot    = totient p1 p2
       e      =  myE tot
       n   = p1  * p2
       rsa_encoded  =  rsa_encode n e $ encode text
       d  =  myD e n tot
       encrypted = concatMap show rsa_encoded
       decrypted = decode $ rsa_decode d n rsa_encoded
   putStrLn ("Encrypted: " ++ encrypted )
   putStrLn ("And now decrypted: " ++ decrypted )
