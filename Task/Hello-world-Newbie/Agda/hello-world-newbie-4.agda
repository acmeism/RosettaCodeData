module HelloWorld where

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit renaming (⊤ to Unit)
open import Agda.Builtin.String using (String)

postulate putStrLn : String -> IO Unit
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}

main : IO Unit
main = putStrLn "Hello world!"
