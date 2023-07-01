{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables        #-}

module Rosetta.AbelianSandpileModel.ST
    ( simulate
    , test
    , toPGM
    ) where

import Control.Monad.Reader (asks, MonadReader (..), ReaderT, runReaderT)
import Control.Monad.ST (runST, ST)
import Control.Monad.State (evalStateT, forM_, lift, MonadState (..), StateT, modify, when)
import Data.Array.ST (freeze, readArray, STUArray, thaw, writeArray)
import Data.Array.Unboxed (array, assocs, bounds, UArray, (!))
import Data.Word (Word32)
import System.IO (hPutStr, hPutStrLn, IOMode (WriteMode), withFile)
import Text.Printf (printf)

type Point     = (Int, Int)
type ArrayST s = STUArray s Point Word32
type ArrayU    = UArray Point Word32

newtype M s a = M (ReaderT (S s) (StateT [Point] (ST s)) a)
    deriving (Functor, Applicative, Monad, MonadReader (S s), MonadState [Point])

data S s = S
    { bMin :: !Point
    , bMax :: !Point
    , arr  :: !(ArrayST s)
    }

runM :: M s a -> S s -> [Point]-> ST s a
runM (M m) = evalStateT . runReaderT m

liftST :: ST s a -> M s a
liftST = M . lift . lift

simulate :: ArrayU -> ArrayU
simulate a = runST $ simulateST a

simulateST :: forall s. ArrayU -> ST s ArrayU
simulateST a = do
    let (p1, p2) = bounds a
        s = [p | (p, c) <- assocs a, c >= 4]
    b <- thaw a :: ST s (ArrayST s)
    let st = S { bMin = p1
               , bMax = p2
               , arr  = b
               }
    runM simulateM st s

simulateM :: forall s. M s ArrayU
simulateM = do
    ps <- get
    case ps of
        []      -> asks arr >>= liftST . freeze
        p : ps' -> do
            c <- changeArr p $ \x -> x - 4
            when (c < 4) $ put ps'
            forM_ [north, east, south, west] $ inc . ($ p)
            simulateM

changeArr :: Point -> (Word32 -> Word32) -> M s Word32
changeArr p f = do
    a    <- asks arr
    oldC <- liftST $ readArray a p
    let newC = f oldC
    liftST $ writeArray a p newC
    return newC

inc :: Point -> M s ()
inc p = do
    b <- inBounds p
    when b $ do
        c <- changeArr p succ
        when (c == 4) $ modify $ (p :)

inBounds :: Point -> M s Bool
inBounds p = do
    st <- ask
    return $ p >= bMin st && p <= bMax st

north, east, south, west :: Point -> Point
north (x, y) = (x, y + 1)
east  (x, y) = (x + 1, y)
south (x, y) = (x, y - 1)
west  (x, y) = (x - 1, y)

toPGM :: ArrayU -> FilePath -> IO ()
toPGM a fp = withFile fp WriteMode $ \h -> do
    let ((x1, y1), (x2, y2)) = bounds a
        width  = x2 - x1 + 1
        height = y2 - y1 + 1
    hPutStrLn h "P2"
    hPutStrLn h $ show width ++ " " ++ show height
    hPutStrLn h "3"
    forM_ [y1 .. y2] $ \y -> do
        forM_ [x1 .. x2] $ \x -> do
            let c = min 3 $ a ! (x, y)
            hPutStr h $ show c ++ " "
        hPutStrLn h ""

initArray :: Int -> Word32 -> ArrayU
initArray size height = array
    ((-size, -size), (size, size))
    [((x, y), if x == 0 && y == 0 then height else 0) | x <- [-size .. size], y <- [-size .. size]]

test :: Int -> Word32 -> IO ()
test size height = do
    printf "size = %d, height = %d\n" size height
    let a  = initArray size height
        b  = simulate a
        fp = printf "sandpile_%d_%d.pgm" size height
    toPGM b fp
    putStrLn $ "wrote image to " ++ fp
