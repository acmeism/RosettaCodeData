newtype TinyInt = TinyInt Int

instance Checked TinyInt Int where
  check x | x >= 0 && x <= 10  =  Check x
          | otherwise          =  error "Out of range"
