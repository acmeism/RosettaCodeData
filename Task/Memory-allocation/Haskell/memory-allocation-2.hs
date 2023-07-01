import Foreign

typedalloc :: IO ()
typedalloc = do
  w <- malloc
  poke w (100 :: Word32)
  free w
  alloca $ \a -> poke a (100 :: Word32)
