isCollapsible :: String -> Bool
isCollapsible [] = False
isCollapsible [_] = False
isCollapsible (h:t@(x:_)) = h == x || isCollapsible t

collapsed :: String -> String
collapsed [] = []
collapsed [x] = [x]
collapsed (h:t@(x:_))
  | h == x = collapsed t
  | otherwise = h : collapsed t
