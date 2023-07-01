import Data.List
import Data.Array
import Control.Monad
import Control.Arrow
import Matrix.LU

ppoly p x = map (x**) p

polyfit d ry = elems $ solve mat vec  where
   mat = listArray ((1,1), (d,d)) $ liftM2 concatMap ppoly id [0..fromIntegral $ pred d]
   vec = listArray (1,d) $ take d ry
