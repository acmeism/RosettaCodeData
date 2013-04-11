module ShortCircuit where

import Prelude hiding ((&&), (||))
import Debug.Trace

False && _     = False
True  && False = False
_     && _     = True

True  || _     = True
False || True  = True
_     || _     = False

a p = trace ("<a " ++ show p ++ ">") p
b p = trace ("<b " ++ show p ++ ">") p

main = mapM_ print (    [ a p || b q | p <- [False, True], q <- [False, True] ]
                     ++ [ a p && b q | p <- [False, True], q <- [False, True] ])
