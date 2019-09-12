import Data.List (tails)

animals :: [String]
animals =
  [ "fly.\nI don't know why she swallowed a fly.\nPerhaps she'll die.\n"
  , "spider.\nThat wiggled and jiggled and tickled inside her."
  , "bird.\t\nHow absurd, to swallow a bird."
  , "cat.\t\nImagine that. She swallowed a cat."
  , "dog.\t\nWhat a hog to swallow a dog."
  , "goat.\t\nShe just opened her throat and swallowed a goat."
  , "cow.\nI don't know how she swallowed a cow."
  , "horse.\nShe's dead, of course."
  ]

beginnings :: [String]
beginnings = ("There was an old lady who swallowed a " ++) <$> animals

lastVerse :: [String]
lastVerse =
  reverse
    [ "She swallowed the " ++
     takeWhile (/= '.') y ++ " to catch the " ++ takeWhile (/= '\t') x
    | (x:y:_:_) <- tails animals ]

main :: IO ()
main =
  putStr $
  concatMap unlines $
  zipWith (:) beginnings $ reverse $ ([] :) (tails lastVerse)
