--import Data.List.Split (splitOn)    -- if the import is available
splitOn :: Char -> String -> [String] -- otherwise
splitOn delim = foldr (\x rest ->
                        if x == delim then "" : rest
                        else (x:head rest):tail rest) [""]

htmlEscape :: String -> String
htmlEscape =  concatMap escapeChar
              where escapeChar '<' = "&lt;"
                    escapeChar '>' = "&gt;"
                    escapeChar '&' = "&amp;"
                    escapeChar '"' = "&quot;" --"
                    escapeChar c   = [c]

toHtmlRow :: [String] -> String
toHtmlRow []   = "<tr></tr>"
toHtmlRow cols = let htmlColumns = concatMap toHtmlCol cols
                  in "<tr>\n" ++ htmlColumns  ++ "</tr>"
               where toHtmlCol x = "  <td>" ++ htmlEscape x ++ "</td>\n"

csvToTable :: String -> String
csvToTable csv = let rows = map (splitOn ',') $ lines csv
                     html = unlines $ map toHtmlRow rows
                  in "<table>\n" ++ html ++ "</table>"

main = interact csvToTable
