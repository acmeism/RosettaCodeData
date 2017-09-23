import Data.List
import Control.Arrow
import Data.Ord

data HTree a
  = Leaf a
  | Branch (HTree a)
           (HTree a)
  deriving (Show, Eq, Ord)

test :: String -> IO ()
test =
  mapM_ (\(a, b) -> putStrLn ('\'' : a : "\' : " ++ b)) .
  serialize . huffmanTree . freq

serialize :: HTree a -> [(a, String)]
serialize (Branch l r) =
  (second ('0' :) <$> serialize l) ++ (second ('1' :) <$> serialize r)
serialize (Leaf x) = [(x, "")]

huffmanTree
  :: (Ord w, Num w)
  => [(w, a)] -> HTree a
huffmanTree =
  snd .
  head . until (null . tail) hstep . sortBy (comparing fst) . (second Leaf <$>)

hstep
  :: (Ord a, Num a)
  => [(a, HTree b)] -> [(a, HTree b)]
hstep ((w1, t1):(w2, t2):wts) =
  insertBy (comparing fst) (w1 + w2, Branch t1 t2) wts

freq
  :: Ord a
  => [a] -> [(Int, a)]
freq = ((length &&& head) <$>) . group . sort
