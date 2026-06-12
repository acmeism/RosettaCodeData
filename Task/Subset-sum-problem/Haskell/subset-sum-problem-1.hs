combinations :: Int -> [a] -> [[a]]
combinations 0 _      = [[]]
combinations _ []     = []
combinations k (x:xs) = map (x:) (combinations (k - 1) xs) ++
                          combinations k xs

data W = W { word   :: String,
             weight :: Int }

solver :: [W] -> [[W]]
solver it = [comb | n <- [1 .. length it],
                    comb <- combinations n it,
                    sum (map weight comb) == 0]

items =  [W "alliance"    (-624),  W "archbishop" (-915),
          W "balm"          397,   W "bonnet"       452,
          W "brute"         870,   W "centipede"  (-658),
          W "cobol"         362,   W "covariate"    590,
          W "departure"     952,   W "deploy"        44,
          W "diophantine"   645,   W "efferent"      54,
          W "elysee"      (-326),  W "eradicate"    376,
          W "escritoire"    856,   W "exorcism"   (-983),
          W "fiat"          170,   W "filmy"      (-874),
          W "flatworm"      503,   W "gestapo"      915,
          W "infra"       (-847),  W "isis"       (-982),
          W "lindholm"      999,   W "markham"      475,
          W "mincemeat"   (-880),  W "moresby"      756,
          W "mycenae"       183,   W "plugging"   (-266),
          W "smokescreen"   423,   W "speakeasy"  (-745),
          W "vein"          813]

main = print $ map word $ head $ solver items
