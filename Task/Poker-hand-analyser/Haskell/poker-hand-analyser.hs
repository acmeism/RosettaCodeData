{-# LANGUAGE TupleSections #-}

import Data.Function (on)
import Data.List     (group, nub, any, sort, sortBy)
import Data.Maybe    (mapMaybe)
import Text.Read     (readMaybe)

data Suit = Club | Diamond | Spade | Heart deriving (Show, Eq)

data Rank = Ace | Two | Three | Four | Five | Six | Seven
          | Eight | Nine | Ten | Jack | Queen | King
          deriving (Show, Eq, Enum, Ord, Bounded)

data Card = Card { suit :: Suit, rank :: Rank } deriving (Show, Eq)

type Hand = [Card]

consumed = pure . (, "")

instance Read Suit where
  readsPrec d s = case s of "♥" -> consumed Heart
                            "♦" -> consumed Diamond
                            "♣" -> consumed Spade
                            "♠" -> consumed Club
                            "h" -> consumed Heart
                            _   -> []

instance Read Rank where
  readsPrec d s = case s of "a"  -> consumed Ace
                            "2"  -> consumed Two
                            "3"  -> consumed Three
                            "4"  -> consumed Four
                            "5"  -> consumed Five
                            "6"  -> consumed Six
                            "7"  -> consumed Seven
                            "8"  -> consumed Eight
                            "9"  -> consumed Nine
                            "10" -> consumed Ten
                            "j"  -> consumed Jack
                            "q"  -> consumed Queen
                            "k"  -> consumed King
                            _    -> []

instance Read Card where
  readsPrec d = fmap (, "") . mapMaybe card . lex
    where
      card (r, s) = Card <$> (readMaybe s :: Maybe Suit)
                         <*> (readMaybe r :: Maybe Rank)

-- Special hand
acesHigh :: [Rank]
acesHigh = [Ace, Ten, Jack, Queen, King]

isSucc :: (Enum a, Eq a, Bounded a) => [a] -> Bool
isSucc []  = True
isSucc [x] = True
isSucc (x:y:zs) = (x /= maxBound && y == succ x) && isSucc (y:zs)

nameHand :: Hand -> String
nameHand [] = "Invalid Input"
nameHand cards | invalidHand          = "Invalid hand"
               | straight && flush    = "Straight flush"
               | ofKind 4             = "Four of a kind"
               | ofKind 3 && ofKind 2 = "Full house"
               | flush                = "Flush"
               | straight             = "Straight"
               | ofKind 3             = "Three of a kind"
               | uniqRanks == 3       = "Two pair"
               | uniqRanks == 4       = "One pair"
               | otherwise            = "High card"
 where
  sortedRank  = sort $ rank <$> cards
  rankCounts  = sortBy (compare `on` snd) $ (,) <$> head <*> length <$> group sortedRank
  uniqRanks   = length rankCounts
  ofKind n    = any ((==n) . snd) rankCounts
  straight    = isSucc sortedRank || sortedRank == acesHigh
  flush       = length (nub $ suit <$> cards) == 1
  invalidHand = length (nub cards) /= 5

testHands :: [(String, Hand)]
testHands = (,) <$> id <*> mapMaybe readMaybe . words <$>
  [ "2♥ 2♦ 2♣ k♣ q♦"
  , "2♥ 5♥ 7♦ 8♣ 9♠"
  , "a♥ 2♦ 3♣ 4♣ 5♦"
  , "2♥ 3♥ 2♦ 3♣ 3♦"
  , "2♥ 7♥ 2♦ 3♣ 3♦"
  , "2♥ 7♥ 7♦ 7♣ 7♠"
  , "10♥ j♥ q♥ k♥ a♥"
  , "4♥ 4♠ k♠ 5♦ 10♠"
  , "q♣ 10♣ 7♣ 6♣ 4♣"
  , "q♣ 10♣ 7♣ 6♣ 7♣" -- duplicate cards
  , "Bad input" ]

main :: IO ()
main = mapM_ (putStrLn . (fst <> const ": " <> nameHand . snd)) testHands
