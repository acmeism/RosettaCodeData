{-# LANGUAGE BangPatterns, LambdaCase #-}

import Control.Monad (mfilter)
import Crypto.Hash.SHA256 (hash)
import qualified Data.ByteString as B
import Data.ByteString.Builder (byteStringHex, char7, hPutBuilder)
import Data.Functor ((<&>))
import Data.Maybe (listToMaybe)
import Data.Strict.Tuple (Pair(..))
import qualified Data.Strict.Tuple as T
import System.Environment (getArgs)
import System.IO (Handle, stdin, stdout)
import System.IO.Streams (InputStream)
import qualified System.IO.Streams as S
import Text.Read (readMaybe)

type Node a    = Pair Int a
type LevelPred = Int -> Int -> Bool
type Combine a = a -> a -> a

-- From a stream of nodes construct the root of a tree from the bottom up.  For
-- each level of the tree pairs of nodes are combined to form a parent node one
-- level higher.  Use a stack to store nodes waiting to be combined with another
-- node on their level.  (An exception to this is at the end of processing,
-- where all the nodes on the stack can be combined.)
build :: Combine a -> [Node a] -> InputStream (Node a) -> IO (Maybe (Node a))
build combine !stack is = S.read is >>= \case
  Nothing -> return $ listToMaybe $ reduce always combine stack
  Just h  -> build combine (reduce (==) combine (h:stack)) is

-- Given a predicate, combining function and a stack, then as long as the
-- predicate is true, repeatedly replace the two top values on the stack with
-- their combined values.
reduce :: LevelPred -> Combine a -> [Node a] -> [Node a]
reduce prd combine (x@(i :!: _):y@(j :!: _):zs)
  | prd i j = reduce prd combine (nodeLift combine y x : zs)
reduce _ _ zs = zs

-- Apply a combining function to the values in two nodes while calculating the
-- appropriate level for the new node.
nodeLift :: Combine a -> Node a -> Node a -> Node a
nodeLift f (i :!: x) (j :!: y) = max i j + 1 :!: f x y

always :: a -> b -> Bool
always _ _ = True

-- Build a SHA256-based Merkle tree using bytes read from a handle, and hashing
-- the data using the given chunk size.
merkleTreeSha256 :: Int -> Handle -> IO (Maybe B.ByteString)
merkleTreeSha256 sz h = mkHash <&> fmap T.snd
  where mkHash = S.makeInputStream getBuf >>=
                 S.map (\bs -> 0 :!: hash bs) >>=
                 build (\x y -> hash (x `B.append` y)) []
        getBuf = B.hGet h sz <&> (mfilter (/= B.empty) . Just)

-- Print a ByteString in hex.
printByteStringHex :: B.ByteString -> IO ()
printByteStringHex = hPutBuilder stdout . (<> char7 '\n') . byteStringHex

main :: IO ()
main = getArgs <&> map readMaybe >>= \case
  [Just sz] -> merkleTreeSha256 sz stdin >>= \case
                 Nothing -> putStrLn "No input to hash"
                 Just h  -> printByteStringHex h
  _         -> putStrLn "Argument usage: chunk-size"
