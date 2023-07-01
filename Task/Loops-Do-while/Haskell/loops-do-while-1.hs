import Data.List
import Control.Monad
import Control.Arrow

doWhile p f n = (n:) $ takeWhile p $ unfoldr (Just.(id &&& f)) $ succ n
