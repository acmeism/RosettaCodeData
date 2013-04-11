import qualified Data.Set as S

htree :: (Ord t, Num t, Ord a) => S.Set (t, HTree a) -> HTree a
htree ts | S.null ts_1 = t1
         | otherwise = htree ts_3
           where
             ((w1,t1), ts_1) = S.deleteFindMin ts
             ((w2,t2), ts_2) = S.deleteFindMin ts_1
             ts_3 = S.insert (w1 + w2, Branch t1 t2) ts_2

huffmanTree :: (Ord w, Num w, Ord a) => [(w, a)] -> HTree a
huffmanTree =  htree . S.fromList . map (second Leaf)
