{-# OPTIONS_GHC -XOverloadedStrings #-}
import Data.Text (splitOn,intercalate)
import qualified Data.Text.IO as T (putStrLn)

main = T.putStrLn . intercalate "." $ splitOn "," "Hello,How,Are,You,Today"
