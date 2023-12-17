{-# LANGUAGE DeriveGeneric #-}

module Main (main) where

import qualified Data.ByteString.Lazy as ByteString (readFile, writeFile)
import           Data.Binary (Binary)
import qualified Data.Binary as Binary (decode, encode)
import           GHC.Generics (Generic)

data Employee =
    Manager String String
    | IndividualContributor String String
    deriving (Generic, Show)
instance Binary Employee

main :: IO ()
main = do
    ByteString.writeFile "objects.dat" $ Binary.encode
        [ IndividualContributor "John Doe" "Sales"
        , Manager "Jane Doe" "Engineering"
        ]

    bytes <- ByteString.readFile "objects.dat"
    let employees = Binary.decode bytes
    print (employees :: [Employee])
