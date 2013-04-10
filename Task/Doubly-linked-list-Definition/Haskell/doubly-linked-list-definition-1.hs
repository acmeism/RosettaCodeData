import qualified Data.Map as M

type NodeID = Maybe Rational
data Node a = Node
   {vNode :: a,
    pNode, nNode :: NodeID}
type DLList a = M.Map Rational (Node a)

empty = M.empty

singleton a = M.singleton 0 $ Node a Nothing Nothing

fcons :: a -> DLList a -> DLList a
fcons a list | M.null list = singleton a
             | otherwise   = M.insert newid new $
                             M.insert firstid changed list
  where (firstid, Node firstval _ secondid) = M.findMin list
        newid = firstid - 1
        new     = Node a        Nothing      (Just firstid)
        changed = Node firstval (Just newid) secondid

rcons :: a -> DLList a -> DLList a
rcons a list | M.null list = singleton a
             | otherwise   = M.insert lastid changed $
                             M.insert newid new list
  where (lastid, Node lastval penultimateid _) = M.findMax list
        newid = lastid + 1
        changed = Node lastval penultimateid (Just newid)
        new     = Node a       (Just lastid) Nothing

mcons :: a -> Node a -> Node a -> DLList a -> DLList a
mcons a n1 n2 = M.insert n1id left .
    M.insert midid mid . M.insert n2id right
  where Node n1val farleftid   (Just n2id) = n1
        Node n2val (Just n1id) farrightid  = n2
        midid = (n1id + n2id) / 2   -- Hence the use of Rationals.
        mid = Node a (Just n1id) (Just n2id)
        left  = Node n1val farleftid    (Just midid)
        right = Node n2val (Just midid) farrightid

firstNode :: DLList a -> Node a
firstNode = snd . M.findMin

lastNode :: DLList a -> Node a
lastNode = snd . M.findMax

nextNode :: DLList a -> Node a -> Maybe (Node a)
nextNode l n = nNode n >>= flip M.lookup l

prevNode :: DLList a -> Node a -> Maybe (Node a)
prevNode l n = pNode n >>= flip M.lookup l

fromList = foldr fcons empty

toList = map vNode . M.elems
