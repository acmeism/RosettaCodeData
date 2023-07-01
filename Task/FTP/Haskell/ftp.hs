module Main (main) where

import           Control.Exception (bracket)
import           Control.Monad (void)
import           Data.Foldable (for_)
import           Network.FTP.Client
                    ( cwd
                    , easyConnectFTP
                    , getbinary
                    , loginAnon
                    , nlst
                    , quit
                    , setPassive
                    )

main :: IO ()
main = bracket ((flip setPassive) True <$> easyConnectFTP "ftp.kernel.org") quit $ \h -> do
    -- Log in anonymously
    void $ loginAnon h

    -- Change directory
    void $ cwd h "/pub/linux/kernel/Historic"

    -- List current directory
    fileNames <- nlst h Nothing
    for_ fileNames $ \fileName ->
        putStrLn fileName

    -- Download in binary mode
    (fileData, _) <- getbinary h "linux-0.01.tar.gz.sign"
    print fileData
