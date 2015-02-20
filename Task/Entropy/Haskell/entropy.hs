import Data.List

main = print $ entropy "1223334444"

entropy s =
 sum . map lg' . fq' . map (fromIntegral.length) . group . sort $ s
  where lg' c = (c * ) . logBase 2 $ 1.0 / c
        fq' c = let sc = sum c in map (/ sc) c
