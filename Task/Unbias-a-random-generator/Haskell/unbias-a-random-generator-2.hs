unbiased :: (MonadRandom m, Eq x) => m x -> m x
unbiased g = do x <- g
                y <- g
                if x /= y then return y else unbiased g
