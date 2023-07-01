{-# LANGUAGE Arrows #-}
import Text.XML.HXT.Arrow
{- For HXT version >= 9.0, use instead:
import Text.XML.HXT.Core
-}

deepElem name = deep (isElem >>> hasName name)

process = proc doc -> do
  item <- single (deepElem "item") -< doc
  _ <- listA (arrIO print <<< deepElem "price") -< doc
  names <- listA (deepElem "name") -< doc
  returnA -< (item, names)

main = do
  [(item, names)] <- runX (readDocument [] "xmlpath.xml" >>> process)
  print item
  print names
