{-# LANGUAGE RecordWildCards #-}

import System.IO
import Data.List (intercalate)

data Gecos = Gecos { fullname  :: String
                   , office    :: String
                   , extension :: String
                   , homephone :: String
                   , email     :: String
                   }

data Record = Record { account   :: String
                     , password  :: String
                     , uid       :: Int
                     , gid       :: Int
                     , directory :: String
                     , shell     :: String
                     , gecos     :: Gecos
                     }

instance Show Gecos where
    show (Gecos {..}) = intercalate "," [fullname, office, extension, homephone, email]

instance Show Record where
    show (Record {..}) = intercalate ":" [account, password, show uid, show gid, show gecos, directory, shell]

addRecord :: String -> Record -> IO ()
addRecord path r = appendFile path (show r)
