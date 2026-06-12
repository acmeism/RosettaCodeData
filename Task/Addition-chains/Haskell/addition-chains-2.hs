task :: Int -> IO()
task n =
  let ch = chains total n
      br = filter isBrauer ch
      nbr = filter (not . isBrauer) ch
  in do
    printf "L(%d) = %d\n" n (length (head ch) - 1)
    printf "Brauer chains(%i)\t: count = %i\tEx: %s\n" n (length br) (show $ reverse $ head br)
    if not $ null nbr
      then
      printf "non-Brauer chains(%i)\t: count = %i\tEx: %s\n\n" n (length ch - length br) (show $ reverse $ head nbr)
      else
      putStrLn "No non Brauer chains\n"
