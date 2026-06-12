import Data.Array.Diff

findEulerianCircuit :: DiffArray Int [Int] -> Maybe [Int]
findEulerianCircuit graph0 = go graph0 [] [start]
  where
    start = fst $ bounds graph0
    go graph circuit []
      | all null (elems graph) = Just circuit
      | otherwise              = Nothing
    go graph circuit (current:stack)
      | null edges = go graph (current:circuit) stack
      | otherwise  = go graph1 circuit (next:current:stack)
      where
        edges = graph ! current
        next = head edges
        graph1 = graph // [(current, tail edges)]

graph1, graph2 :: DiffArray Int [Int]
graph1 = listArray (0,2) [[1],[2],[0]]
graph2 = listArray (0,6) [[1,6],[2],[0,3],[4],[2,5],[0],[4]]
