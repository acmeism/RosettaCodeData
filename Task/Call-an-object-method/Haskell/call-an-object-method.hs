data Obj = Obj { field :: Int, method :: Int -> Int }

-- smart constructor
mkAdder :: Int -> Obj
mkAdder x = Obj x (+x)

-- adding method from a type class
instanse Show Obj where
  show o = "Obj " ++ show (field o)
