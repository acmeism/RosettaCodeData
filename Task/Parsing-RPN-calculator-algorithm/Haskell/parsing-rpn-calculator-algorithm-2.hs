calcRPNLog :: String -> ([Double],[(String, [Double])])
calcRPNLog input = mkLog $ zip commands $ tail result
  where result = scanl interprete [] commands
        commands = words input
        mkLog [] = ([], [])
        mkLog res = (snd $ last res, res)
