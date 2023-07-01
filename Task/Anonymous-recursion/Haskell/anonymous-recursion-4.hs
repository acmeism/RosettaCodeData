fib :: Integer -> Maybe Integer
fib n
  | n < 0 = Nothing
  | otherwise =
    Just $
    (\f ->
        let x = f x
        in x)
      (\f n ->
          if n > 1
            then f (n - 1) + f (n - 2)
            else 1)
      n

-- TEST ----------------------------------------------------------------------
main :: IO ()
main =
  print $
  fib <$> [-4 .. 10] >>=
  \m ->
     case m of
       Just x -> [x]
       _ -> []
