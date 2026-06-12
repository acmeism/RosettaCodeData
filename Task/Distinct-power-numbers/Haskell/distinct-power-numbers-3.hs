import Control.Applicative (liftA2)
import Control.Monad (join)
import qualified Data.Set as S

main :: IO ()
main =
  (print . S.elems . S.fromList) $
    join
      (liftA2 (^))
      [2 .. 5]
