data Banana = Foo -- the implementation doesn't really matter in this case
instance Eatable Banana where
  eat _ = "I'm eating a banana"
