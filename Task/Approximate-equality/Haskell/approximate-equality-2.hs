test :: [(Double, Double)]
test = [(100000000000000.01, 100000000000000.011)
       ,(100.01, 100.011)
       ,(10000000000000.001 / 10000.0, 1000000000.0000001000)
       ,(0.001, 0.0010000001)
       ,(0.000000000000000000000101, 0.0)
       ,(sqrt 2 * sqrt 2, 2.0)
       ,(-sqrt 2 * sqrt 2, -2.0)
       ,(3.141592653589793, 3.141592653589794)
       ,(3.141592653589, 3.141592653589794)]

-- requires import Text.Printf
main = mapM_ runTest test
  where
    runTest (a, b) = do
      printf "%f == %f %v\n" a b (show $ a==b) :: IO ()
      printf "%f ~= %f %v\n\n" a b (show $ a~=b)
