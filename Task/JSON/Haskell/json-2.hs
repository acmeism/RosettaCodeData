{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
import Data.Aeson
import Data.Aeson.TH

data Person = Person { firstName :: String
                     , lastName  :: String
                     , age :: Maybe Int
                     } deriving (Show, Eq)

$(deriveJSON defaultOptions ''Person)

main = do
    let test1 = "{\"firstName\":\"Bob\", \"lastName\":\"Smith\"}"
        test2 = "{\"firstName\":\"Miles\", \"lastName\":\"Davis\", \"age\": 45}"
    print (decode test1 :: Maybe Person)
    print (decode test2 :: Maybe Person)
