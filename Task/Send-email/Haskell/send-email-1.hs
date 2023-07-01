{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Network.Mail.SMTP
                    ( Address(..)
                    , htmlPart
                    , plainTextPart
                    , sendMailWithLogin'
                    , simpleMail
                    )

main :: IO ()
main =
    sendMailWithLogin' "smtp.example.com" 25 "user" "password" $
        simpleMail
            (Address (Just "From Example") "from@example.com")
            [Address (Just "To Example") "to@example.com"]
            [] -- CC
            [] -- BCC
            "Subject"
            [ plainTextPart "This is plain text."
            , htmlPart "<h1>Title</h1><p>This is HTML.</p>"
            ]
