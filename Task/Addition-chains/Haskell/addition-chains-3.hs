extraTask :: Int -> IO()
extraTask n =
  let ch = chains brauer n
  in do
    printf "L(%d) = %d\n" n (length (head ch) - 1)
    printf "Brauer chains(%i)\t: count = %i\tEx: %s\n" n (length ch) (show $ reverse $ head ch)
    putStrLn "Non-Brauer analysis suppressed\n"

main = mapM_ extraTask [47, 79, 191, 382, 379]
