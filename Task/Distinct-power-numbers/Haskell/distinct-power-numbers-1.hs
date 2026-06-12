import qualified Data.Set as S


------------------ DISTINCT POWER NUMBERS ----------------

distinctPowerNumbers :: Int -> Int -> [Int]
distinctPowerNumbers a b =
  (S.elems . S.fromList) $
    (fmap (^) >>= (<*>)) [a .. b]


--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    distinctPowerNumbers 2 5
