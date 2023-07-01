import Data.Char (toLower)
import Data.List (sortBy)
import Data.Ord (comparing)

-------------------- CUSTOM COMPARATORS ------------------

lengthThenAZ :: String -> String -> Ordering
lengthThenAZ = comparing length <> comparing (fmap toLower)

descLengthThenAZ :: String -> String -> Ordering
descLengthThenAZ =
  flip (comparing length)
    <> comparing (fmap toLower)

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    ( fmap
        unlines
        ( [sortBy] <*> [lengthThenAZ, descLengthThenAZ]
            <*> [ [ "Here",
                    "are",
                    "some",
                    "sample",
                    "strings",
                    "to",
                    "be",
                    "sorted"
                  ]
                ]
        )
    )
