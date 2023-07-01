{-# LANGUAGE OverloadedStrings #-}

import Data.Text hiding (length)

--------- COUNT OF SUBSTRING INSTANCES IN A STRING -------

countAll :: Text -> Text -> Int
countAll needle haystack =
  length
    (breakOnAll needle haystack)

--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    countAll "ab"
      <$> [ "ababababab",
            "abelian absurdity",
            "babel kebab"
          ]
