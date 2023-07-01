{-# LANGUAGE TemplateHaskell #-}
import Lens.Micro
import Lens.Micro.TH
import Data.List (union, delete)

type Preferences a = (a, [a])
type Couple a = (a,a)
data State a = State { _freeGuys :: [a]
                     , _guys :: [Preferences a]
                     , _girls :: [Preferences a]}

makeLenses ''State
