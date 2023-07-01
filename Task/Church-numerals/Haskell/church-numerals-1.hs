import Unsafe.Coerce ( unsafeCoerce )

type Church a = (a -> a) -> a -> a

churchZero :: Church  a
churchZero = const id

churchOne :: Church a
churchOne = id

succChurch :: Church a -> Church a
succChurch = (<*>) (.) -- add one recursion, or \ ch f -> f . ch f

addChurch :: Church a -> Church a -> Church a
addChurch = (<*>). fmap (.) -- or \ ach bch f -> ach f . bch f

multChurch :: Church a -> Church a -> Church a
multChurch = (.) -- or \ ach bch -> ach . bch

expChurch :: Church a -> Church a -> Church a
expChurch basech expch = unsafeCoerce expch basech

isChurchZero :: Church a -> Church a
isChurchZero ch = unsafeCoerce ch (const churchZero) churchOne

predChurch :: Church a -> Church a
predChurch ch f x = unsafeCoerce ch (\ g h -> h (g f)) (const x) id

minusChurch :: Church a -> Church a -> Church a
minusChurch ach bch = unsafeCoerce bch predChurch ach

-- counts the times divisor can be subtracted from dividend to zero...
divChurch :: Church a -> Church a -> Church a
divChurch dvdnd dvsr =
  let divr n d =
        (\ v -> v (const $ succChurch $ divr v d) -- if branch
                  churchZero -- else branch
        ) (minusChurch n d)
  in divr (unsafeCoerce succChurch dvdnd) $ unsafeCoerce dvsr

churchFromInt :: Int -> Church a
churchFromInt 0 = churchZero
churchFromInt n = succChurch $ churchFromInt (n - 1)

-- Or as a fold:
-- churchFromInt n = foldr (.) id . replicate n

-- Or as an iterated application:
-- churchFromInt n = iterate succChurch churchZero !! n

intFromChurch :: Church Int -> Int
intFromChurch ch = ch succ 0

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
