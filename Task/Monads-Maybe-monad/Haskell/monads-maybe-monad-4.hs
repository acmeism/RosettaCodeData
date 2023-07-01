import Control.Monad ((>=>))

safeVersion :: (a -> b) -> (a -> Bool) -> a -> Maybe b
safeVersion f fnSafetyCheck x | fnSafetyCheck x = Just (f x)
                              | otherwise       = Nothing

safeReciprocal = safeVersion (1/) (/=0)
safeRoot = safeVersion sqrt (>=0)
safeLog = safeVersion log (>0)

safeLogRootReciprocal = safeReciprocal >=> safeRoot >=> safeLog

main = print $ map safeLogRootReciprocal [-2, -1, -0.5, 0, exp (-1), 1, 2, exp 1, 3, 4, 5]
