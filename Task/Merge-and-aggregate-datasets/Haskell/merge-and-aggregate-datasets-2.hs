tabulateDB (DB ps) header cols = intercalate "|" <$> body
  where
    body = transpose $ zipWith pad width table
    table = transpose $ header : map showPatient ps
    showPatient p = sequence cols p
    width = maximum . map length <$> table
    pad n col = (' ' :) . take (n+1) . (++ repeat ' ') <$> col

main = do
  a <- readDB <$> readFile "patients.csv"
  b <- readDB <$> readFile "visits.csv"
  mapM_ putStrLn $ tabulateDB (a <> b) header fields
  where
    header = [ "PATIENT_ID", "LASTNAME", "VISIT_DATE"
             , "SCORES SUM","SCORES AVG"]
    fields = [ pid
             , fromMaybe [] . name
             , \p -> case visits p of {[] -> []; l -> last l}
             , \p -> case scores p of {[] -> []; s -> show (sum s)}
             , \p -> case scores p of {[] -> []; s -> show (mean s)} ]

    mean lst = sum lst / genericLength lst
