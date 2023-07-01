import Foreign

bytealloc :: IO ()
bytealloc = do
  a0 <- mallocBytes 100 -- Allocate 100 bytes
  free a0 -- Free them again
  allocaBytes 100 $ \a -> -- Allocate 100 bytes; automatically
                          -- freed when closure finishes
    poke (a::Ptr Word32) 0
