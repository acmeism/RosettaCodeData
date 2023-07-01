{-# OPTIONS -fglasgow-exts #-}

data Check a b = Check { unCheck :: b } deriving (Eq, Ord)

class Checked a b where
  check :: b -> Check a b

lift  f x = f (unCheck x)
liftc f x = check $ f (unCheck x)

lift2  f x y = f (unCheck x) (unCheck y)
lift2c f x y = check $ f (unCheck x) (unCheck y)
lift2p f x y = (check u, check v) where (u,v) = f (unCheck x) (unCheck y)

instance Show b => Show (Check a b) where
  show (Check x)        = show x
  showsPrec p (Check x) = showsPrec p x

instance (Enum b, Checked a b) => Enum (Check a b) where
  succ = liftc succ
  pred = liftc pred
  toEnum   = check . toEnum
  fromEnum = lift fromEnum

instance (Num b, Checked a b) => Num (Check a b) where
  (+) = lift2c (+)
  (-) = lift2c (-)
  (*) = lift2c (*)
 negate = liftc negate
  abs    = liftc abs
   signum = liftc signum
  fromInteger = check . fromInteger

instance (Real b, Checked a b) => Real (Check a b) where
  toRational = lift toRational

instance (Integral b, Checked a b) => Integral (Check a b) where
  quot = lift2c quot
  rem  = lift2c rem
  div  = lift2c div
  mod  = lift2c mod
  quotRem = lift2p quotRem
  divMod  = lift2p divMod
  toInteger = lift toInteger
