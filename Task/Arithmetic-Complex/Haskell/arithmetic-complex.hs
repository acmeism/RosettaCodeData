import Data.Complex

main = do
  let a = 1.0 :+ 2.0    -- complex number 1+2i
  let b = 4             -- complex number 4+0i
  -- 'b' is inferred to be complex because it's used in
  -- arithmetic with 'a' below.
  putStrLn $ "Add:      " ++ show (a + b)
  putStrLn $ "Subtract: " ++ show (a - b)
  putStrLn $ "Multiply: " ++ show (a * b)
  putStrLn $ "Divide:   " ++ show (a / b)
  putStrLn $ "Negate:   " ++ show (-a)
  putStrLn $ "Inverse:  " ++ show (recip a)
  putStrLn $ "Conjugate:" ++ show (conjugate a)
