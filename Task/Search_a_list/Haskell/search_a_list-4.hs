import Control.Monad
import Control.Arrow

*Main> map (ap (,) (flip elemIndex haystack)) needles
[("Washington",Nothing),("Bush",Just 4)]
