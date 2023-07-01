{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Data.Foldable (for_)
import qualified Data.Text.Encoding as Text (encodeUtf8)
import           Ldap.Client (Attr(..), Filter(..))
import qualified Ldap.Client as Ldap (Dn(..), Host(..), search, with, typesOnly)

main :: IO ()
main = do
    entries <- Ldap.with (Ldap.Plain "localhost") 389 $ \ldap ->
        Ldap.search ldap (Ldap.Dn "o=example.com") (Ldap.typesOnly True) (Attr "uid" := Text.encodeUtf8 "user") []
    for_ entries $ \entry ->
        print entry
