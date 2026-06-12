------ REMOVE A SPECIFIC SUBSET OF GLYPHS FROM A STRING ----

exceptGlyphs :: String -> String -> String
exceptGlyphs = filter . flip notElem


---------------------------- TEST --------------------------
txt :: String
txt =
  "Rosetta Code is a programming chrestomathy site.\n\
  \The idea is to present solutions to the same\n\
  \task in as many different languages as possible,\n\
  \to demonstrate how languages are similar and\n\
  \different, and to aid a person with a grounding\n\
  \in one approach to a problem in learning another."

main :: IO ()
main = putStrLn $ exceptGlyphs "eau" txt
