p && q = case p of
           False -> False
           _     -> case q of
                      False -> False
                      _     -> True

p || q = case p of
           True -> True
           _    -> case q of
                      True -> True
                      _    -> False
