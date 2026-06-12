import Control.Monad (join)
import Data.Bifunctor (bimap, first, second)
import Data.Bool (bool)
import Data.Char (toUpper)
import qualified Data.Set as S

----- SETS OF UNIQUE VOWELS AND CONSONANTS IN A STRING ---

vowelsAndConsonantsUsed ::
  String -> String -> String -> (S.Set Char, S.Set Char)
vowelsAndConsonantsUsed vowels alphabet =
  foldr
    ( \c vc ->
        if_
          (S.member c vs)
          (first (S.insert c))
          (if_ (S.member c cs) (second (S.insert c)) id)
          vc
    )
    (S.empty, S.empty)
  where
    vs = S.fromList $ vowels <> fmap toUpper vowels
    cs =
      S.fromList $
        filter
          (`S.notMember` vs)
          (alphabet <> fmap toUpper alphabet)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn "Unique vowels and consonants used, with counts:\n"
  mapM_ print $
    [(,) . S.toList <*> S.size]
      <*> ( [fst, snd]
              <*> [ vowelsAndConsonantsUsed
                      "aeiou"
                      ['a' .. 'z']
                      "Forever Fortran 2018 programming language"
                  ]
          )

------------------------- GENERAL ------------------------

both :: (a -> b) -> (a, a) -> (b, b)
both = join bimap

if_ :: Bool -> a -> a -> a
if_ p t f =
  if p
    then t
    else f
