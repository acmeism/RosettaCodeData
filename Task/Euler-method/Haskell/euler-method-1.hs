-- the solver
dsolveBy _ _ [] _ = error "empty solution interval"
dsolveBy method f mesh x0 = zip mesh results
  where results = scanl (method f) x0 intervals
        intervals = zip mesh (tail mesh)
