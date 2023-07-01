carpet :: Int -> String
carpet = unlines . (iterate weave ["██"] !!)

weave :: [String] -> [String]
weave =
  let thread = zipWith (<>)
   in ( (>>=)
          . ( (:)
                <*> ( ((:) . fmap (fmap (const ' ')))
                        <*> return
                    )
            )
      )
        <*> ((.) <$> flip thread <*> thread)

main :: IO ()
main = mapM_ (putStrLn . carpet) [0 .. 2]
