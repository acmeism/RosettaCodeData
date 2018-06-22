{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables #-}

import Data.Array
import Data.Foldable (length, concat, sum)
import Data.List (genericLength)
import Data.Maybe (mapMaybe)
import Prelude hiding (length, concat, sum)
import qualified Data.Map.Strict as Map

{-
A SimpleMesh consists of only vertices and faces that refer to them.
A Mesh extends the SimpleMesh to contain edges as well as references to
adjoining mesh components for each other component, such as a vertex
also contains what faces it belongs to.
An isolated edge can be represented as a degenerate face with 2 vertices.
Faces with 0 or 1 vertices can be thrown out, as they do not contribute to
the result (they can also propagate NaNs).
-}

newtype VertexId = VertexId { getVertexId :: Int } deriving (Ix, Ord, Eq, Show)
newtype EdgeId = EdgeId { getEdgeId :: Int } deriving (Ix, Ord, Eq, Show)
newtype FaceId = FaceId { getFaceId :: Int } deriving (Ix, Ord, Eq, Show)

data Vertex a = Vertex
  { vertexPoint :: a
  , vertexEdges :: [EdgeId]
  , vertexFaces :: [FaceId]
  } deriving Show

data Edge = Edge
  { edgeVertexA :: VertexId
  , edgeVertexB :: VertexId
  , edgeFaces :: [FaceId]
  } deriving Show

data Face = Face
  { faceVertices :: [VertexId]
  , faceEdges :: [EdgeId]
  } deriving Show

type VertexArray a = Array VertexId (Vertex a)
type EdgeArray = Array EdgeId Edge
type FaceArray = Array FaceId Face

data Mesh a = Mesh
  { meshVertices :: VertexArray a
  , meshEdges :: EdgeArray
  , meshFaces :: FaceArray
  } deriving Show

data SimpleVertex a = SimpleVertex { sVertexPoint :: a } deriving Show
data SimpleFace = SimpleFace { sFaceVertices :: [VertexId] } deriving Show

type SimpleVertexArray a = Array VertexId (SimpleVertex a)
type SimpleFaceArray = Array FaceId SimpleFace

data SimpleMesh a = SimpleMesh
  { sMeshVertices :: SimpleVertexArray a
  , sMeshFaces :: SimpleFaceArray
  } deriving Show

-- Generic helpers.
fmap1 :: Functor f => (t -> a -> b) -> (t -> f a) -> t -> f b
fmap1 g h x = fmap (g x) (h x)

aZipWith :: Ix i1 => (a -> b -> e) -> Array i1 a -> Array i b -> Array i1 e
aZipWith f a b = listArray (bounds a) $ zipWith f (elems a) (elems b)

average :: (Foldable f, Fractional a) => f a -> a
average xs = (sum xs) / (fromIntegral $ length xs)

-- Intermediary point types for ultimately converting into a point `a`.
newtype FacePoint a = FacePoint { getFacePoint :: a } deriving Show
newtype EdgeCenterPoint a = EdgeCenterPoint { getEdgeCenterPoint :: a } deriving Show
newtype EdgePoint a = EdgePoint { getEdgePoint :: a } deriving Show
newtype VertexPoint a = VertexPoint { getVertexPoint :: a } deriving Show

type FacePointArray a = Array FaceId (FacePoint a)
type EdgePointArray a = Array EdgeId (EdgePoint a)
type EdgeCenterPointArray a = Array EdgeId (EdgeCenterPoint a)
type IsEdgeHoleArray = Array EdgeId Bool
type VertexPointArray a = Array VertexId (VertexPoint a)

-- Subdivision helpers.
facePoint :: Fractional a => Mesh a -> Face -> FacePoint a
facePoint mesh = FacePoint . average . (fmap $ vertexPointById mesh) . faceVertices

allFacePoints :: Fractional a => Mesh a -> FacePointArray a
allFacePoints = fmap1 facePoint meshFaces

vertexPointById :: Mesh a -> VertexId -> a
vertexPointById mesh = vertexPoint . (meshVertices mesh !)

edgeCenterPoint :: Fractional a => Mesh a -> Edge -> EdgeCenterPoint a
edgeCenterPoint mesh (Edge ea eb _)
  = EdgeCenterPoint . average $ fmap (vertexPointById mesh) [ea, eb]

allEdgeCenterPoints :: Fractional a => Mesh a -> EdgeCenterPointArray a
allEdgeCenterPoints = fmap1 edgeCenterPoint meshEdges

allIsEdgeHoles :: Mesh a -> IsEdgeHoleArray
allIsEdgeHoles = fmap ((< 2) . length . edgeFaces) . meshEdges

edgePoint :: Fractional a => Edge -> FacePointArray a -> EdgeCenterPoint a -> EdgePoint a
edgePoint (Edge _ _ [_]) _ (EdgeCenterPoint ecp) = EdgePoint ecp
edgePoint (Edge _ _ faceIds) facePoints (EdgeCenterPoint ecp)
  = EdgePoint $ average [ecp, average $ fmap (getFacePoint . (facePoints !)) faceIds]

allEdgePoints :: Fractional a => Mesh a -> FacePointArray a -> EdgeCenterPointArray a -> EdgePointArray a
allEdgePoints mesh fps ecps = aZipWith (\e ecp -> edgePoint e fps ecp) (meshEdges mesh) ecps

vertexPoint' :: Fractional a => Vertex a -> FacePointArray a -> EdgeCenterPointArray a -> IsEdgeHoleArray -> VertexPoint a
vertexPoint' vertex facePoints ecps iehs
  | length faceIds == length edgeIds = VertexPoint newCoords
  | otherwise = VertexPoint avgHoleEcps
  where
    newCoords = (oldCoords * m1) + (avgFacePoints * m2) + (avgMidEdges * m3)
    oldCoords = vertexPoint vertex
    avgFacePoints = average $ fmap (getFacePoint . (facePoints !)) faceIds
    avgMidEdges = average $ fmap (getEdgeCenterPoint . (ecps !)) edgeIds
    m1 = (n - 3) / n
    m2 = 1 / n
    m3 = 2 / n
    n = genericLength faceIds
    faceIds = vertexFaces vertex
    edgeIds = vertexEdges vertex
    avgHoleEcps = average . (oldCoords:) . fmap (getEdgeCenterPoint . (ecps !)) $ filter (iehs !) edgeIds

allVertexPoints :: Fractional a => Mesh a -> FacePointArray a -> EdgeCenterPointArray a -> IsEdgeHoleArray -> VertexPointArray a
allVertexPoints mesh fps ecps iehs = fmap (\v -> vertexPoint' v fps ecps iehs) (meshVertices mesh)

-- For each vertex in a face, generate a set of new faces from it with its vertex point,
-- neighbor edge points, and face point. The new faces will refer to vertices in the
-- combined vertex array.
newFaces :: Face -> FaceId -> Int -> Int -> [SimpleFace]
newFaces (Face vertexIds edgeIds) faceId epOffset vpOffset
  = take (genericLength vertexIds)
  $ zipWith3 newFace (cycle vertexIds) (cycle edgeIds) (drop 1 (cycle edgeIds))
  where
    f = VertexId . (+ epOffset) . getEdgeId
    newFace vid epA epB = SimpleFace
      [ VertexId . (+ vpOffset) $ getVertexId vid
      , f epA
      , VertexId $ getFaceId faceId
      , f epB]

subdivide :: Fractional a => SimpleMesh a -> SimpleMesh a
subdivide simpleMesh
  = SimpleMesh combinedVertices (listArray (FaceId 0, FaceId (genericLength faces - 1)) faces)
  where
    mesh = makeComplexMesh simpleMesh
    fps = allFacePoints mesh
    ecps = allEdgeCenterPoints mesh
    eps = allEdgePoints mesh fps ecps
    iehs = allIsEdgeHoles mesh
    vps = allVertexPoints mesh fps ecps iehs
    edgePointOffset = length fps
    vertexPointOffset = edgePointOffset + length eps
    combinedVertices
      = listArray (VertexId 0, VertexId (vertexPointOffset + length vps - 1))
      . fmap SimpleVertex
      $ concat [ fmap getFacePoint $ elems fps
               , fmap getEdgePoint $ elems eps
               , fmap getVertexPoint $ elems vps]
    faces
      = concat $ zipWith (\face fid -> newFaces face fid edgePointOffset vertexPointOffset)
      (elems $ meshFaces mesh) (fmap FaceId [0..])

-- Transform to a Mesh by filling in the missing references and generating edges.
-- Faces can be updated with their edges, but must be ordered.
-- Edge and face order does not matter for vertices.
-- TODO: Discard degenerate faces (ones with 0 to 2 vertices/edges),
-- or we could transform these into single edges or vertices.
makeComplexMesh :: forall a. SimpleMesh a -> Mesh a
makeComplexMesh (SimpleMesh sVertices sFaces) = Mesh vertices edges faces
  where
    makeEdgesFromFace :: SimpleFace -> FaceId -> [Edge]
    makeEdgesFromFace (SimpleFace vertexIds) fid
      = take (genericLength vertexIds)
      $ zipWith (\a b -> Edge a b [fid]) verts (drop 1 verts)
      where
        verts = cycle vertexIds

    edgeKey :: VertexId -> VertexId -> (VertexId, VertexId)
    edgeKey a b = (min a b, max a b)

    sFacesList :: [SimpleFace]
    sFacesList = elems sFaces

    fids :: [FaceId]
    fids = fmap FaceId [0..]

    eids :: [EdgeId]
    eids = fmap EdgeId [0..]

    faceEdges :: [[Edge]]
    faceEdges = zipWith makeEdgesFromFace sFacesList fids

    edgeMap :: Map.Map (VertexId, VertexId) Edge
    edgeMap
      = Map.fromListWith (\(Edge a b fidsA) (Edge _ _ fidsB) -> Edge a b (fidsA ++ fidsB))
      . fmap (\edge@(Edge a b _) -> (edgeKey a b, edge))
      $ concat faceEdges

    edges :: EdgeArray
    edges = listArray (EdgeId 0, EdgeId $ (Map.size edgeMap) - 1) $ Map.elems edgeMap

    edgeIdMap :: Map.Map (VertexId, VertexId) EdgeId
    edgeIdMap = Map.fromList $ zipWith (\(Edge a b _) eid -> ((edgeKey a b), eid)) (elems edges) eids

    faceEdgeIds :: [[EdgeId]]
    faceEdgeIds = fmap (mapMaybe (\(Edge a b _) -> Map.lookup (edgeKey a b) edgeIdMap)) faceEdges

    faces :: FaceArray
    faces
      = listArray (FaceId 0, FaceId $ (length sFaces) - 1)
      $ zipWith (\(SimpleFace verts) edgeIds -> Face verts edgeIds) sFacesList faceEdgeIds

    vidsToFids :: Map.Map VertexId [FaceId]
    vidsToFids
      = Map.fromListWith (++)
      . concat
      $ zipWith (\(SimpleFace vertexIds) fid -> fmap (\vid -> (vid, [fid])) vertexIds) sFacesList fids

    vidsToEids :: Map.Map VertexId [EdgeId]
    vidsToEids
      = Map.fromListWith (++)
      . concat
      $ zipWith (\(Edge a b _) eid -> [(a, [eid]), (b, [eid])]) (elems edges) eids

    simpleToComplexVert :: SimpleVertex a -> VertexId -> Vertex a
    simpleToComplexVert (SimpleVertex point) vid
      = Vertex point
      (Map.findWithDefault [] vid vidsToEids)
      (Map.findWithDefault [] vid vidsToFids)

    vertices :: VertexArray a
    vertices
      = listArray (bounds sVertices)
      $ zipWith simpleToComplexVert (elems sVertices) (fmap VertexId [0..])

pShowSimpleMesh :: Show a => SimpleMesh a -> String
pShowSimpleMesh (SimpleMesh vertices faces)
  = "Vertices:\n" ++ (arrShow vertices sVertexPoint)
  ++ "Faces:\n" ++ (arrShow faces (fmap getVertexId . sFaceVertices))
  where
    arrShow a f = concatMap ((++ "\n") . show . (\(i, e) -> (i, f e))) . zip [0 :: Int ..] $ elems a

-- Testing types.
data Point a = Point a a a deriving (Show)

instance Functor Point where
  fmap f (Point x y z) = Point (f x) (f y) (f z)

zipPoint :: (a -> b -> c) -> Point a -> Point b -> Point c
zipPoint f (Point x y z) (Point x' y' z') = Point (f x x') (f y y') (f z z')

instance Num a => Num (Point a) where
  (+) = zipPoint (+)
  (-) = zipPoint (-)
  (*) = zipPoint (*)
  negate = fmap negate
  abs = fmap abs
  signum = fmap signum
  fromInteger i = let i' = fromInteger i in Point i' i' i'

instance Fractional a => Fractional (Point a) where
  recip = fmap recip
  fromRational r = let r' = fromRational r in Point r' r' r'

testCube :: SimpleMesh (Point Double)
testCube = SimpleMesh vertices faces
  where
    vertices = listArray (VertexId 0, VertexId 7)
      $ fmap SimpleVertex
      [ Point (-1) (-1) (-1)
      , Point (-1) (-1) 1
      , Point (-1) 1 (-1)
      , Point (-1) 1 1
      , Point 1 (-1) (-1)
      , Point 1 (-1) 1
      , Point 1 1 (-1)
      , Point 1 1 1]
    faces = listArray (FaceId 0, FaceId 5)
      $ fmap (SimpleFace . (fmap VertexId))
      [ [0, 4, 5, 1]
      , [4, 6, 7, 5]
      , [6, 2, 3, 7]
      , [2, 0, 1, 3]
      , [1, 5, 7, 3]
      , [0, 2, 6, 4]]

testCubeWithHole :: SimpleMesh (Point Double)
testCubeWithHole
  = SimpleMesh (sMeshVertices testCube) (ixmap (FaceId 0, FaceId 4) id (sMeshFaces testCube))

testTriangle :: SimpleMesh (Point Double)
testTriangle = SimpleMesh vertices faces
  where
    vertices = listArray (VertexId 0, VertexId 2)
      $ fmap SimpleVertex
      [ Point 0 0 0
      , Point 0 0 1
      , Point 0 1 0]
    faces = listArray (FaceId 0, FaceId 0)
      $ fmap (SimpleFace . (fmap VertexId))
      [ [0, 1, 2]]

main :: IO ()
main = putStr . pShowSimpleMesh $ subdivide testCube
