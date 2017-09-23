module Main where

import Control.Applicative ((<$>), (<*>))
import Control.Monad (foldM, forM_)
import Data.List ((\\))

-- types
data House = House
    { color :: Color      -- <trait> :: House -> <Trait>
    , man   :: Man
    , pet   :: Pet
    , drink :: Drink
    , smoke :: Smoke
    }
    deriving (Eq, Show)

data Color = Red | Green | Blue | Yellow | White
    deriving (Eq, Show, Enum, Bounded)

data Man = Eng | Swe | Dan | Nor | Ger
    deriving (Eq, Show, Enum, Bounded)

data Pet = Dog | Birds | Cats | Horse | Zebra
    deriving (Eq, Show, Enum, Bounded)

data Drink = Coffee | Tea | Milk | Beer | Water
    deriving (Eq, Show, Enum, Bounded)

data Smoke = PallMall | Dunhill | Blend | BlueMaster | Prince
    deriving (Eq, Show, Enum, Bounded)

type Solution = [House]

main :: IO ()
main = do
  forM_ solutions $ \sol -> mapM_ print sol
                            >> putStrLn "----"
  putStrLn "No More Solutions"


solutions :: [Solution]
solutions = filter finalCheck . map reverse $ foldM next [] [1..5]
    where
      -- NOTE: list of houses is generated in reversed order
      next :: Solution -> Int -> [Solution]
      next sol pos = [h:sol | h <- newHouses sol, consistent h pos]


newHouses :: Solution -> Solution
newHouses sol =    -- all combinations of traits not yet used
    House <$> new color <*> new man <*> new pet <*> new drink <*> new smoke
    where
      new trait = [minBound ..] \\ map trait sol  -- :: [<Trait>]


consistent :: House -> Int -> Bool
consistent house pos = and                  -- consistent with the rules:
    [ man   `is` Eng     <=>   color `is` Red              --  2
    , man   `is` Swe     <=>   pet   `is` Dog              --  3
    , man   `is` Dan     <=>   drink `is` Tea              --  4
    , color `is` Green   <=>   drink `is` Coffee           --  6
    , pet   `is` Birds   <=>   smoke `is` PallMall         --  7
    , color `is` Yellow  <=>   smoke `is` Dunhill          --  8
    , const (pos == 3)   <=>   drink `is` Milk             --  9
    , const (pos == 1)   <=>   man   `is` Nor              -- 10
    , drink `is` Beer    <=>   smoke `is` BlueMaster       -- 13
    , man   `is` Ger     <=>   smoke `is` Prince           -- 14
    ]
    where
      infix 4 <=>
      p <=> q  =  p house == q house   -- both True or both False


is :: Eq a => (House -> a) -> a -> House -> Bool
(trait `is` value) house  =  trait house == value


finalCheck :: [House] -> Bool
finalCheck solution = and                    -- fulfills the rules:
    [ (color `is` Green)   `leftOf` (color `is` White)  --  5
    , (smoke `is` Blend  ) `nextTo` (pet   `is` Cats )  -- 11
    , (smoke `is` Dunhill) `nextTo` (pet   `is` Horse)  -- 12
    , (color `is` Blue   ) `nextTo` (man   `is` Nor  )  -- 15
    , (smoke `is` Blend  ) `nextTo` (drink `is` Water)  -- 16
    ]
    where
      nextTo :: (House -> Bool) -> (House -> Bool) -> Bool
      nextTo p q = leftOf p q || leftOf q p
      leftOf p q
          | (_:h:_) <- dropWhile (not . p) solution = q h
          | otherwise                               = False
