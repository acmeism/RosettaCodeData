accumulator = newSTRef >=> return . factory
  where factory s n = modifySTRef s (+ n) >> readSTRef s
