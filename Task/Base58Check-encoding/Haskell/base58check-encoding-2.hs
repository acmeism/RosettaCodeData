import Data.Array (Array, listArray, (!))
import Numeric (showHex, showIntAtBase)

------------------- BASE58CHECK ENCODING -----------------

base58Encode ::
  (Integral a, Show a) =>
  a ->
  String
base58Encode =
  baseEncode $
    listArray (0, 57) $
      [ ('1', '9'),
        ('A', 'H'),
        ('J', 'N'),
        ('P', 'Z'),
        ('a', 'k'),
        ('m', 'z')
      ]
        >>= uncurry enumFromTo

baseEncode ::
  (Show a, Integral a) =>
  Array Int Char ->
  a ->
  String
baseEncode cs n =
  showIntAtBase
    (fromIntegral $ length cs)
    (cs !)
    n
    []

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    fTable
      "Base 58 encoding:\n"
      (("0x" <>) . flip showHex [])
      base58Encode
      id
      [ 25420294593250030202636073700053352635053786165627414518,
        0x61,
        0x626262,
        0x636363,
        0x73696d706c792061206c6f6e6720737472696e67,
        0x516b6fcd0f,
        0xbf4f89001e670274dd,
        0x572e4794,
        0xecac89cad93923c02321,
        0x10c8511e
      ]

-------------------- OUTPUT FORMATTING -------------------
fTable ::
  String ->
  (a -> String) ->
  (b -> String) ->
  (a -> b) ->
  [a] ->
  String
fTable s xShow fxShow f xs =
  let w = maximum $ fmap length (xShow <$> xs)
      rjust n c = (drop . length) <*> (replicate n c <>)
   in unlines $
        s :
        fmap
          ( ((<>) . rjust w ' ' . xShow)
              <*> ((" -> " <>) . fxShow . f)
          )
          xs
