------------- SHIFT LIST ELEMENTS TO LEFT BY N -----------

rotated :: Int -> [a] -> [a]
rotated n =
  ( (<*>) take
      . flip (drop . mod n)
      . cycle
  )
    <*> length

--------------------------- TEST -------------------------
main :: IO ()
main =
  let xs = [1 .. 9]
   in putStrLn ("Initial list: " <> show xs <> "\n")
        >> putStrLn "Rotated 3 or 30 positions to the left:"
        >> print (rotated 3 xs)
        >> print (rotated 30 xs)
        >> putStrLn "\nRotated 3 or 30 positions to the right:"
        >> print (rotated (-3) xs)
        >> print (rotated (-30) xs)
