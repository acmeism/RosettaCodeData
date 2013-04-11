*Main> mapM_ print $ map (id &&& soundexSimple) ["Soundex", "Example", "Sownteks", "Ekzampul"]
("Soundex","S532")
("Example","E251")
("Sownteks","S532")
("Ekzampul","E251")
