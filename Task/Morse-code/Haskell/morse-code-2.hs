module MorseCode (Morse, MSym(..), toMorse) where

import Data.List
import Data.Maybe
import qualified Data.Map as M

type Morse = [MSym]
data MSym = Dot | Dash | SGap | CGap | WGap deriving (Show)

-- Based on the table of International Morse Code letters and numerals at
-- http://en.wikipedia.org/wiki/Morse_code.
dict = M.fromList
       [('a', m ".-"   ), ('b', m "-..." ), ('c', m "-.-." ), ('d', m "-.."  ),
        ('e', m "."    ), ('f', m "..-." ), ('g', m "--."  ), ('h', m "...." ),
        ('i', m ".."   ), ('j', m ".---" ), ('k', m "-.-"  ), ('l', m ".-.." ),
        ('m', m "--"   ), ('n', m "-."   ), ('o', m "---"  ), ('p', m ".--." ),
        ('q', m "--.-" ), ('r', m ".-."  ), ('s', m "..."  ), ('t', m "-"    ),
        ('u', m "..-"  ), ('v', m "...-" ), ('w', m ".--"  ), ('x', m "-..-" ),
        ('y', m "-.--" ), ('z', m "--.." ), ('1', m ".----"), ('2', m "..---"),
        ('3', m "...--"), ('4', m "....-"), ('5', m "....."), ('6', m "-...."),
        ('7', m "--..."), ('8', m "---.."), ('9', m "----."), ('0', m "-----")]
    where m = intersperse SGap . map toSym
          toSym '.' = Dot
          toSym '-' = Dash

-- Convert a string to a stream of Morse symbols.  We enhance the usual dots
-- and dashes with special "gap" symbols, which indicate the border between
-- symbols, characters and words.  This allows a player to easily adjust its
-- timing by simply looking at the current symbol, rather than trying to keep
-- track of state.
toMorse :: String -> Morse
toMorse = fromWords . words . weed
    where fromWords = intercalate [WGap] . map fromWord
          fromWord  = intercalate [CGap] . map fromChar
          fromChar  = fromJust . flip M.lookup dict
          weed      = filter (\c -> c == ' ' || M.member c dict)
