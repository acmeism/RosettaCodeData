import Control.Monad.Error
import Control.Monad.Trans (lift)

-- Our "user-defined exception" tpe
data MyError = U0 | U1 | Other deriving (Eq, Read, Show)

-- Required for any error type
instance Error MyError where
  noMsg    = Other
  strMsg _ = Other

-- Throwing and catching exceptions implies that we are working in a monad. In
-- this case, we use ErrorT to support our user-defined exceptions, wrapping
-- IO to be able to report the happenings. ('lift' converts ErrorT e IO a
-- actions into IO a actions.)

foo = do lift (putStrLn "foo")
         mapM_ (\toThrow -> bar toThrow                      -- the protected call
                              `catchError` \caught ->        -- the catch operation
                                                             -- ↓ what to do with it
                                 case caught of U0 -> lift (putStrLn "foo caught U0")
                                                _  -> throwError caught)
               [U0, U1]                                      -- the two exceptions to throw


bar toThrow = do lift (putStrLn " bar")
                 baz toThrow

baz toThrow = do lift (putStrLn "  baz")
                 throwError toThrow

-- We cannot use exceptions without at some outer level choosing what to do
-- if an exception propagates all the way up. Here we just print the exception
-- if there was one.
main = do result <- runErrorT foo
          case result of
            Left e  -> putStrLn ("Caught error at top level: " ++ show e)
            Right v -> putStrLn ("Return value: " ++ show v)
