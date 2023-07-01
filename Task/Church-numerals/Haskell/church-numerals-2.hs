{-# LANGUAGE RankNTypes #-}

newtype Church = Church { unChurch :: forall a. (a -> a) -> a -> a }

churchZero :: Church
churchZero = Church $ const id

succChurch :: Church -> Church
succChurch ch = Church $ (<*>) (.) $ unChurch ch -- add one recursion

addChurch :: Church -> Church -> Church
addChurch ach bch =
  Church $ ((<*>) . fmap (.)) (unChurch ach) (unChurch bch)

multChurch :: Church -> Church -> Church
multChurch ach bch = Church $ unChurch ach . unChurch bch

expChurch :: Church -> Church -> Church
expChurch basech expch = Church $ unChurch expch $ unChurch basech

predChurch :: Church -> Church
predChurch ch = Church $ \ f x ->
  unChurch ch (\ g h -> h (g f)) (const x) id

minusChurch :: Church -> Church -> Church
minusChurch ach bch = unChurch bch predChurch ach

isChurchZero :: Church -> Church
isChurchZero ch = unChurch ch (const churchZero) $ Church id

divChurch :: Church -> Church -> Church
divChurch dvdnd dvsr =
  let divr n =
        (\ v -> unChurch v
                  (const $ succChurch $ divr v)
                  churchZero
        )(minusChurch n dvsr)
  in divr (succChurch dvdnd)

churchFromInt :: Int -> Church
churchFromInt 0 = churchZero
churchFromInt n = succChurch $ churchFromInt (n - 1)

-- Or as a fold:
-- churchFromInt n = foldr (.) id . replicate n

-- Or as an iterated application:
-- churchFromInt n = iterate succChurch churchZero !! n

intFromChurch :: Church -> Int
intFromChurch ch = unChurch ch succ 0

------------------------------------- TEST -------------------------------------
main :: IO ()
main = do
  let [cThree, cFour, cEleven, cTwelve] = churchFromInt <$> [3, 4, 11, 12]
  print $ fmap intFromChurch  [ addChurch cThree cFour
                              , multChurch cThree cFour
                              , expChurch cFour cThree
                              , expChurch cThree cFour
                              , isChurchZero churchZero
                              , predChurch cFour
                              , minusChurch cEleven cThree
                              , divChurch cEleven cThree
                              , divChurch cTwelve cThree
                              ]
