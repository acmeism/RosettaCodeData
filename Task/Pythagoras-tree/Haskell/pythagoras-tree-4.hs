main = writeFile "pith.svg" svg
  where svg = "<svg " ++ attrs ++ foldMap (mkLine . close) squares ++ "</svg>"
        attrs = "fill='none' stroke='black' height='400' width='600'>"
        mkLine path = "<polyline points ='" ++ foldMap mkPoint path ++ "'/>"
        mkPoint (x,y) = show (250+x) ++ "," ++ show (400-y) ++ " "
        close lst = lst ++ [head lst]
