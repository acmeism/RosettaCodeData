import Data.Set
import Control.Monad

powerset :: Ord a => Set a -> Set (Set a)
powerset = fromList . fmap fromList . listPowerset . toList

listPowerset :: [a] -> [[a]]
listPowerset = filterM (const [True, False])
