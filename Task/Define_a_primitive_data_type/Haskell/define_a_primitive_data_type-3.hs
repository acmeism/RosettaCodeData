newtype EvenInt = EvenInt Int

 instance Checked EvenInt Int where
   check x | even x     =  Check x
           | otherwise  =  error "Not even"
