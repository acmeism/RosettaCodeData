import Data.List (tails)

-- Once means the phrase is only printed in the verse about that animal.
-- Every means the phrase is printed for every verse.  It is used for "fly",
-- and could optionally be used for "spider", in the version of the song where
-- "wriggled and jiggled..." is repeated every verse.
-- Die is only used for the horse, and means the chain of animals won't be
-- included in the verse.
data AnimalAction
  = Once
  | Every
  | Die

animals =
  [ ("horse", Die, "She's dead, of course!")
  , ("donkey", Once, "It was rather wonky. To swallow a donkey.")
  , ("cow", Once, "I don't know how. To swallow a cow.")
  , ("goat", Once, "She just opened her throat. To swallow a goat.")
  , ("pig", Once, "Her mouth was so big. To swallow a pig.")
  , ("dog", Once, "What a hog. To swallow a dog.")
  , ("cat", Once, "Fancy that. To swallow a cat.")
  , ("bird", Once, "Quite absurd. To swallow a bird.")
  , ("spider", Once, "That wriggled and jiggled and tickled inside her.")
  , ("fly", Every, "I don't know why she swallowed the fly.")
  ]

verse :: [(String, AnimalAction, String)] -> [String]
verse ((anim, act, phrase):restAnims) =
  let lns = ["I know an old lady who swallowed a " ++ anim ++ ".", phrase]
  in case act of
       Die -> lns
       _ -> lns ++ verse' restAnims anim

verse' :: [(String, AnimalAction, String)] -> String -> [String]
verse' [] _ = ["Perhaps she'll die."]
verse' ((anim, act, phrase):restAnims) prevAnim =
  let why = "She swallowed the " ++ prevAnim ++ " to catch the " ++ anim ++ "."
      lns =
        case act of
          Every -> [why, phrase]
          _ -> [why]
  in lns ++ verse' restAnims anim

song :: [String]
song = concatMap verse . tail . reverse $ tails animals

main :: IO ()
main = putStr $ unlines song
