data INI = INI { entries :: [Entry] } deriving Show

data Entry = Comment String
           | Field String String
           | Flag String Bool
           | EmptyLine

instance Show Entry where
  show entry = case entry of
    Comment text -> "# " ++ text
    Field f v    -> f ++ " " ++ v
    Flag f True  -> f
    Flag f False -> "; " ++ f
    EmptyLine    -> ""

instance Read Entry where
  readsPrec _ s = [(interprete (clean " " s), "")]
    where
      clean chs = dropWhile (`elem` chs)
      interprete ('#' : text) = Comment text
      interprete (';' : f)= flag (clean " ;" f) False
      interprete entry = case words entry of
        []    -> EmptyLine
        [f]   -> flag f True
        f : v -> field f (unwords v)
      field f = Field (toUpper <$> f)
      flag f = Flag (toUpper <$> f)
