import Data.Monoid
mycmp s1 s2 = mappend (compare (length s2) (length s1))
                       (compare (map toLower s1) (map toLower s2))
