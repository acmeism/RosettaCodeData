[q,q1,q2] = map quaternionFromList [[1..4],[2..5],[3..6]]
-- a*b == b*a
test :: Quaternion -> Quaternion -> Bool
test a b =  a `mulQ` b == b `mulQ` a
