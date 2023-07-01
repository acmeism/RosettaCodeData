import Data.Map

dict = fromList [("key1","val1"), ("key2","val2")]

ans = Data.Map.lookup "key2" dict  -- evaluates to Just "val2"
