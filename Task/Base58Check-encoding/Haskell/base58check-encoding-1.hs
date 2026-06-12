import Numeric (showIntAtBase)

chars = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

base58Encode :: Integer -> String
base58Encode n = showIntAtBase 58 (chars !!) n ""

main :: IO ()
main = mapM_ (putStrLn . base58Encode)
        [25420294593250030202636073700053352635053786165627414518,
         0x61,
         0x626262,
         0x636363,
         0x73696d706c792061206c6f6e6720737472696e67,
         0x516b6fcd0f,
         0xbf4f89001e670274dd,
         0x572e4794,
         0xecac89cad93923c02321,
         0x10c8511e]
