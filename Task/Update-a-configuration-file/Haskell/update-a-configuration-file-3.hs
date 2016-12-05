setValue :: String -> String -> INI -> INI
setValue f v = INI . replaceOn (eqv f) (Field f v) . entries

setFlag :: String -> Bool -> INI -> INI
setFlag f v = INI . replaceOn (eqv f) (Flag f v) . entries

enable f = setFlag f True
disable f = setFlag f False

eqv f entry = (toUpper <$> f) == (toUpper <$> field entry)
  where field (Field f _) = f
        field (Flag f _) = f
        field _ = ""

replaceOn p x lst = prev ++ x : post
  where
    (prev,post) = case break p lst of
      (lst, []) -> (lst, [])
      (lst, _:xs) -> (lst, xs)
