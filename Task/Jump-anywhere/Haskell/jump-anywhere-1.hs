import Control.Monad.Cont

data LabelT r m = LabelT (ContT r m ())

label :: ContT r m (LabelT r m)
label = callCC subprog
  where subprog lbl = let l = LabelT (lbl l) in return l

goto :: LabelT r m -> ContT r m b
goto (LabelT l) = const undefined <$> l

runProgram :: Monad m => ContT r m r -> m r
runProgram program = runContT program return
