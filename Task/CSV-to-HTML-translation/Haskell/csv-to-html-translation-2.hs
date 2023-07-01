import Data.List (unfoldr)
split p = unfoldr (\s -> case dropWhile p s of [] -> Nothing
                                               ss -> Just $ break p ss)

main = interact (\csv -> "<table>\n" ++
    (unlines $ map ((\cols -> "<tr>\n" ++
        (concatMap (\x -> "  <td>" ++ concatMap (\c ->
            case c of {'<' -> "&lt;"; '>' -> "&gt;";
			'&' -> "&amp;"; '"' -> "&quot;"; _ -> [c]}) x
        ++ "</td>\n") cols)
    ++ "</tr>") . split (==',')) $ lines csv) ++ "</table>")
