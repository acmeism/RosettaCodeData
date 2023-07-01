import Data.Bits

bitwise :: Int -> Int -> IO ()
bitwise a b =
  mapM_
    print
    [ a .&. b
    , a .|. b
    , a `xor` b
    , complement a
    , shiftL a b -- left shift
    , shiftR a b -- arithmetic right shift
    , shift a b -- You can also use the "unified" shift function;
      -- positive is for left shift, negative is for right shift
    , shift a (-b)
    , rotateL a b -- rotate left
    , rotateR a b -- rotate right
    , rotate a b -- You can also use the "unified" rotate function;
      -- positive is for left rotate, negative is for right rotate
    , rotate a (-b)
    ]

main :: IO ()
main = bitwise 255 170
