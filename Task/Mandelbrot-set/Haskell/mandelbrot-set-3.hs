main :: IO ()
main =
  putStrLn $
    concat
      [ go x y
        | y <- [1, 0.98 .. -1],
          x <- [-2, -1.98 .. 0.5]
      ]
  where
    go x y
      | x == (-2) = "\n"
      | otherwise =
        let (a, b) =
              iterate
                (\(x', y') -> (x' ^ 2 - y' ^ 2 + x, 2 * x' * y' + y))
                (0, 0)
                !! 500
         in ( snd . head . filter fst $
                zip
                  ( [ (< 0.01),
                      (< 0.025),
                      (< 0.05),
                      (< 0.1),
                      (< 0.5),
                      (< 1),
                      (< 4),
                      const True
                    ]
                      <*> [a ^ 2 + b ^ 2]
                  )
                  [".", "\'", ":", "!", "|", "}", "#", " "]
            )
