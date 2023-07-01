import Data.List (group)

isCollapsible :: String -> Bool
isCollapsible = any ((1 <) . length) . group

collapsed :: String -> String
collapsed = map head . group
