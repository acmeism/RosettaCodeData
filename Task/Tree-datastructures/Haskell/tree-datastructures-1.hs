{-# LANGUAGE FlexibleInstances       #-}
{-# LANGUAGE MultiParamTypeClasses   #-}
{-# LANGUAGE UndecidableSuperClasses #-}
{-# LANGUAGE TypeApplications        #-}

import Data.List (span)

-- A nested tree structure.
-- Using `Maybe` allows encoding several zero-level items
-- or irregular lists (see test example)
data Nest a = Nest (Maybe a) [Nest a]
  deriving Eq

instance Show a => Show (Nest a) where
  show (Nest (Just a) []) = show a
  show (Nest (Just a) s) = show a ++ show s
  show (Nest Nothing []) = "\"\""
  show (Nest Nothing s) = "\"\"" ++ show s

-- An indented tree structure.
type Indent a = [(Int, a)]

-- class for isomorphic types
class Iso b a => Iso a b where
  from :: a -> b

-- A bijection from nested form to indent form
instance Iso (Nest a) (Indent a) where
  from = go (-1)
    where
      go n (Nest a t) =
        case a of
          Just a -> (n, a) : foldMap (go (n + 1)) t
          Nothing -> foldMap (go (n + 1)) t

-- A bijection from indent form to nested form
instance Iso (Indent a) (Nest a) where
  from = revNest . foldl add (Nest Nothing [])
    where
      add t (d,x) = go 0 t
        where
          go n (Nest a s) =
            case compare n d of
              EQ -> Nest a $ Nest (Just x) [] : s
              LT -> case s of
                      h:t -> Nest a $ go (n+1) h : t
                      [] -> go n $ Nest a [Nest Nothing []]
              GT -> go (n-1) $ Nest Nothing [Nest a s]

      revNest (Nest a s) = Nest a (reverse $ revNest <$> s)

-- A bijection from indent form to a string
instance Iso (Indent String) String where
  from = unlines . map process
    where
      process (d, s) = replicate (4*d) ' ' ++ s

-- A bijection from a string to indent form
instance Iso String (Indent String) where
  from = map process . lines
    where
      process s = let (i, a) = span (== ' ') s
                  in (length i `div` 4, a)

-- A bijection from nest form to a string via indent form
instance Iso (Nest String) String where
  from = from @(Indent String) . from

-- A bijection from a string to nest form via indent form
instance Iso String (Nest String) where
  from = from @(Indent String) . from
