import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

------- ANY DIGIT ABOVE 9 REQUIRED IN HEXADECIMAL ? ------

p :: Int -> Bool
p n =
  9 < n
    && ( 9 < rem n 16
           || p (quot n 16)
       )

--------------------------- TEST -------------------------
main :: IO ()
main =
  let upperLimit = 500
      xs = [show x | x <- [0 .. upperLimit], p x]
   in mapM_
        putStrLn
        [ show (length xs)
            <> " matches up to "
            <> show upperLimit
            <> ":\n",
          table justifyRight " " $ chunksOf 15 xs
        ]

------------------------- DISPLAY ------------------------

table ::
  (Int -> Char -> String -> String) ->
  String ->
  [[String]] ->
  String
table alignment gap rows =
  unlines $
    fmap
      ( intercalate gap
          . zipWith (`alignment` ' ') colWidths
      )
      rows
  where
    colWidths = maximum . fmap length <$> transpose rows

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
