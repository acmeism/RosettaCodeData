{-# LANGUAGE TemplateHaskell #-}
-- build with "ghc --make beer.hs"
module Main where
import Language.Haskell.TH
import Control.Monad.Writer

-- This is calculated at compile time, and is equivalent to
-- songString = "99 bottles of beer on the wall\n99 bottles..."
songString =
    $(let
         sing = tell -- we can't sing very well...

         someBottles 1 = "1 bottle of beer "
         someBottles n = show n ++ " bottles of beer "

         bottlesOfBeer n = (someBottles n ++)

         verse n = do
           sing $ n `bottlesOfBeer` "on the wall\n"
           sing $ n `bottlesOfBeer` "\n"
           sing $ "Take one down, pass it around\n"
           sing $ (n - 1) `bottlesOfBeer` "on the wall\n\n"

         song = execWriter $ mapM_ verse [99,98..1]

      in return $ LitE $ StringL $ song)

main = putStr songString
