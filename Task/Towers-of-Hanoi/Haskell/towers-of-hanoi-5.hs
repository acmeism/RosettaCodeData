-------------------------- HANOI -------------------------

hanoi ::
  Int ->
  String ->
  String ->
  String ->
  [(String, String)]
hanoi 0 _ _ _ = mempty
hanoi n l r m =
  hanoi (n - 1) l m r
    <> [(l, r)]
    <> hanoi (n - 1) m r l

--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $ showHanoi 5

------------------------- DISPLAY ------------------------
showHanoi :: Int -> String
showHanoi n =
  unlines $
    fmap
      ( \(from, to) ->
          concat [justifyRight 5 ' ' from, " -> ", to]
      )
      (hanoi n "left" "right" "mid")

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
