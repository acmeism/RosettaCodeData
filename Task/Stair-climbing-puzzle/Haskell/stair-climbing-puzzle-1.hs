stepUp :: Robot ()
stepUp = untilM step stepUp

untilM :: Monad m => m Bool -> m () -> m ()
untilM test action = do
    result <- test
    if result then return () else action >> untilM test action
