import Data.List
import Control.Arrow
import Control.Monad

flgInsert x xs = ((x:xs==) &&& id)$ insert x xs

gapSwapping k = (and *** concat. transpose). unzip
  . map (foldr (\x (b,xs) -> first (b &&)$ flgInsert x xs) (True,[]))
  . transpose. takeWhile (not.null). unfoldr (Just. splitAt k)

combSort xs = (snd. fst) $ until (\((b,_),g)-> b && g==1)
    (\((_,xs),g) ->(gapSwapping g xs, fg g)) ((False,xs), fg $ length xs)
  where fg = max 1. truncate. (/1.25). fromIntegral
