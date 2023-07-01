nextCarpet :: [String] -> [String]
nextCarpet carpet = border ++ map f carpet ++ border
  where border = map (concat . replicate 3) carpet
        f x = x ++ map (const ' ') x ++ x

sierpinskiCarpet :: Int -> [String]
sierpinskiCarpet n = iterate nextCarpet ["#"] !! n

main :: IO ()
main = mapM_ putStrLn $ sierpinskiCarpet 3
