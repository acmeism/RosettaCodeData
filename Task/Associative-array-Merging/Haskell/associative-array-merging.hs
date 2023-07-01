data Item = Item
  { name :: Maybe String
  , price :: Maybe Float
  , color :: Maybe String
  , year :: Maybe Int
  } deriving (Show)

itemFromMerge :: Item -> Item -> Item
itemFromMerge (Item n p c y) (Item n1 p1 c1 y1) =
  Item (maybe n pure n1) (maybe p pure p1) (maybe c pure c1) (maybe y pure y1)

main :: IO ()
main =
  print $
  itemFromMerge
    (Item (Just "Rocket Skates") (Just 12.75) (Just "yellow") Nothing)
    (Item Nothing (Just 15.25) (Just "red") (Just 1974))
