import Data.List (findIndex, find)

data City = City
  { name :: String
  , population :: Float
  } deriving (Read, Show)

-- CITY PROPERTIES ------------------------------------------------------------
cityName :: City -> String
cityName (City x _) = x

cityPop :: City -> Float
cityPop (City _ x) = x

mbCityName :: Maybe City -> Maybe String
mbCityName (Just x) = Just (cityName x)
mbCityName _ = Nothing

mbCityPop :: Maybe City -> Maybe Float
mbCityPop (Just x) = Just (cityPop x)
mbCityPop _ = Nothing

-- EXAMPLES -------------------------------------------------------------------
mets :: [City]
mets =
  [ City
    { name = "Lagos"
    , population = 21.0
    }
  , City
    { name = "Cairo"
    , population = 15.2
    }
  , City
    { name = "Kinshasa-Brazzaville"
    , population = 11.3
    }
  , City
    { name = "Greater Johannesburg"
    , population = 7.55
    }
  , City
    { name = "Mogadishu"
    , population = 5.85
    }
  , City
    { name = "Khartoum-Omdurman"
    , population = 4.98
    }
  , City
    { name = "Dar Es Salaam"
    , population = 4.7
    }
  , City
    { name = "Alexandria"
    , population = 4.58
    }
  , City
    { name = "Abidjan"
    , population = 4.4
    }
  , City
    { name = "Casablanca"
    , population = 3.98
    }
  ]

-- TEST -----------------------------------------------------------------------
main :: IO ()
main = do
  mbPrint $ findIndex (("Dar Es Salaam" ==) . cityName) mets
  mbPrint $ mbCityName $ find ((< 5.0) . cityPop) mets
  mbPrint $ mbCityPop $ find (("A" ==) . take 1 . cityName) mets

mbPrint
  :: Show a
  => Maybe a -> IO ()
mbPrint (Just x) = print x
mbPrint x = print x
