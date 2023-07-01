import qualified Text.Parsec as P

showExpansion :: String -> String
showExpansion =
  (<>) . (<> "\n-->\n") <*> (either show unlines . P.parse parser [])

parser :: P.Parsec String u [String]
parser = expansion P.anyChar

expansion :: P.Parsec String u Char -> P.Parsec String u [String]
expansion =
  fmap expand .
  P.many .
  ((P.try alts P.<|> P.try alt1 P.<|> escape) P.<|>) . fmap (pure . pure)

expand :: [[String]] -> [String]
expand = foldr ((<*>) . fmap (<>)) [[]]

alts :: P.Parsec String u [String]
alts = concat <$> P.between (P.char '{') (P.char '}') (alt `sepBy2` P.char ',')

alt :: P.Parsec String u [String]
alt = expansion (P.noneOf ",}")

alt1 :: P.Parsec String u [String]
alt1 =
  (\x -> ['{' : (x <> "}")]) <$>
  P.between (P.char '{') (P.char '}') (P.many $ P.noneOf ",{}")

sepBy2 :: P.Parsec String u a -> P.Parsec String u b -> P.Parsec String u [a]
p `sepBy2` sep = (:) <$> p <*> P.many1 (sep >> p)

escape :: P.Parsec String u [String]
escape = pure <$> sequence [P.char '\\', P.anyChar]

main :: IO ()
main =
  mapM_
    (putStrLn . showExpansion)
    [ "~/{Downloads,Pictures}/*.{jpg,gif,png}"
    , "It{{em,alic}iz,erat}e{d,}, please."
    , "{,{,gotta have{ ,\\, again\\, }}more }cowbell!"
    , "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"
    ]
