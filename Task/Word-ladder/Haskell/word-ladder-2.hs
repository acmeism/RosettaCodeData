wordLadders2 :: String -> String -> [String] -> [[String]]
wordLadders2 start end dict
  | length start /= length end = []
  | otherwise = pure wordSpace >>= expand start end >>= shrink end
  where

    wordSpace = S.fromList $ filter ((length start ==) . length) dict

    expand s e d = tail . map S.elems <$> go [S.singleton s] [S.singleton e] d
      where
        go (hs:ts) (he:te) d
          | S.null d || S.null fs || S.null fe = []
          | not $ S.null f1 = [reverse (f1:te) ++ hs:ts]
          | not $ S.null f2 = [reverse (he:te) ++ f2:ts]
          | not $ S.null f3 = [reverse (he:te) ++ f3:hs:ts]
          | otherwise = go (fs:hs:ts) (fe:he:te) (d S.\\ hs S.\\ he)
          where
            fs = front hs
            fe = front he
            f1 = fs `S.intersection` he
            f2 = fe `S.intersection` hs
            f3 = fs `S.intersection` fe
            front = S.foldr (\w -> S.union (S.filter (oneStepAway w) d)) mempty

    shrink = scanM (findM . oneStepAway)

    oneStepAway x = (1 ==) . distance x

    scanM f x = fmap snd . foldM g (x,[x])
      where g (b, r) a = (\x -> (x, x:r)) <$> f b a

    findM p = msum . map (\x -> if p x then pure x else mzero)
