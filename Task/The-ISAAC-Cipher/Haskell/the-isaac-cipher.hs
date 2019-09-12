import Data.Array (Array, (!), (//), array, elems)
import Data.Word (Word, Word32)
import Data.Bits (shift, xor)
import Data.Char (toUpper)
import Data.List (unfoldr)
import Numeric (showHex)

type IArray = Array Word32 Word32

data IsaacState = IState
  { randrsl :: IArray
  , randcnt :: Word32
  , mm :: IArray
  , aa :: Word32
  , bb :: Word32
  , cc :: Word32
  }

instance Show IsaacState where
  show (IState _ cnt _ a b c) =
    show cnt ++ " " ++ show a ++ " " ++ show b ++ " " ++ show c

toHex :: Char -> String
toHex c = showHex (fromEnum c) ""

hexify :: String -> String
hexify = map toUpper . concatMap toHex

toNum :: Char -> Word32
toNum = fromIntegral . fromEnum

toChar :: Word32 -> Char
toChar = toEnum . fromIntegral

golden :: Word32
golden = 0x9e3779b9

-- Mix up an ordering of words.
mix :: [Word32] -> [Word32]
mix set = foldl aux set [11, -2, 8, -16, 10, -4, 8, -9]
  where
    aux [a, b, c, d, e, f, g, h] x = [b + c, c, d + a_, e, f, g, h, a_]
      where
        a_ = a `xor` (b `shift` x)

-- Generate the next 256 words.
isaac :: IsaacState -> IsaacState
isaac (IState rsl _ m a b c) = IState rsl_ 0 m_ a_ b_ c_
  where
    c_ = c + 1
    (rsl_, m_, a_, b_) =
      foldl aux (rsl, m, a, b) $ zip [0 .. 255] $ cycle [13, -6, 2, -16]
    aux (rsl, m, a, b) (i, s) = (rsl_, m_, a_, b_)
      where
        x = m ! i
        a_ = (a `xor` (a `shift` s)) + m ! ((i + 128) `mod` 256)
        y = a_ + b + m ! ((x `shift` (-2)) `mod` 256)
        m_ = m // [(i, y)]
        b_ = x + m_ ! ((y `shift` (-10)) `mod` 256)
        rsl_ = rsl // [(i, b_)]

-- Given a seed value in randrsl, initialize/mixup the state.
randinit :: IsaacState -> Bool -> IsaacState
randinit state flag = isaac (IState randrsl_ 0 m 0 0 0)
  where
    firstSet = iterate mix (replicate 8 golden) !! 4
    iter _ _ [] = []
    iter flag set rsl =
      let (rslH, rslT) = splitAt 8 rsl
          set_ =
            mix $
            if flag
              then zipWith (+) set rslH
              else set
      in set_ ++ iter flag set_ rslT
    randrsl_ = randrsl state
    firstPass = iter flag firstSet $ elems randrsl_
    set_ = drop (256 - 8) firstPass
    secondPass =
      if flag
        then iter True set_ firstPass
        else firstPass
    m = array (0, 255) $ zip [0 ..] secondPass

-- Given a string seed, optionaly use it to generate a new state.
seed :: String -> Bool -> IsaacState
seed key flag =
  let m = array (0, 255) $ zip [0 .. 255] $ repeat 0
      rsl = m // zip [0 ..] (map toNum key)
      state = IState rsl 0 m 0 0 0
  in randinit state flag

-- Produce a random word and the next state from the given state.
random :: IsaacState -> (Word32, IsaacState)
random state@(IState rsl cnt m a b c) =
  let r = rsl ! cnt
      state_ =
        if cnt + 1 > 255
          then isaac $ IState rsl 0 m a b c
          else IState rsl (cnt + 1) m a b c
  in (r, state_)

-- Produce a stream of random words from the given state.
randoms :: IsaacState -> [Word32]
randoms = unfoldr $ Just . random

-- Produce a random printable/typable character in the ascii range
-- and the next state from the given state.
randA :: IsaacState -> (Char, IsaacState)
randA state =
  let (r, state_) = random state
  in (toEnum $ fromIntegral $ (r `mod` 95) + 32, state_)

-- Produce a stream of printable characters from the given state.
randAs :: IsaacState -> String
randAs = unfoldr $ Just . randA

-- Vernam encode/decode a string with the given state.
vernam :: IsaacState -> String -> String
vernam state msg = map toChar $ zipWith xor msg_ randAs_
  where
    msg_ = map toNum msg
    randAs_ = map toNum $ randAs state

main :: IO ()
main = do
  let msg = "a Top Secret secret"
      key = "this is my secret key"
      st = seed key True
      ver = vernam st msg
      unver = vernam st ver
  putStrLn $ "Message: " ++ msg
  putStrLn $ "Key    : " ++ key
  putStrLn $ "XOR    : " ++ hexify ver
  putStrLn $ "XOR dcr: " ++ unver
