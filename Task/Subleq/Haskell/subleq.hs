{-# LANGUAGE FlexibleContexts #-}
import Control.Monad.State
import Data.Char (chr, ord)
import Data.IntMap

subleq = loop 0
    where
      loop ip =
          when (ip >= 0) $
          do m0 <- gets (! ip)
             m1 <- gets (! (ip + 1))
             if m0 < 0
                then do modify . insert m1 ch . ord =<< liftIO getChar
                        loop (ip + 3)
                else if m1 < 0
                        then do liftIO . putChar . chr =<< gets (! m0)
                                loop (ip + 3)
                        else do v <- (-) <$> gets (! m1) <*> gets (! m0)
                                modify $ insert m1 v
                                if v <= 0
                                   then loop =<< gets (! (ip + 2))
                                   else loop (ip + 3)

main = evalStateT subleq helloWorld
    where
      helloWorld =
          fromList $
          zip [0..]
              [15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0, -1, 72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33, 10, 0]
