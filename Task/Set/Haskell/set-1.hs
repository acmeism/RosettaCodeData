Prelude> import Data.Set
Prelude Data.Set> empty :: Set Integer -- Empty set
fromList []
Prelude Data.Set> let s1 = fromList [1,2,3,4,3] -- Convert list into set
Prelude Data.Set> s1
fromList [1,2,3,4]
Prelude Data.Set> let s2 = fromList [3,4,5,6]
Prelude Data.Set> union s1 s2 -- Union
fromList [1,2,3,4,5,6]
Prelude Data.Set> intersection s1 s2 -- Intersection
fromList [3,4]
Prelude Data.Set> s1 \\ s2 -- Difference
fromList [1,2]
Prelude Data.Set> s1 `isSubsetOf` s1 -- Subset
True
Prelude Data.Set> fromList [3,1] `isSubsetOf` s1
True
Prelude Data.Set> s1 `isProperSubsetOf` s1 -- Proper subset
False
Prelude Data.Set> fromList [3,1] `isProperSubsetOf` s1
True
Prelude Data.Set> fromList [3,2,4,1] == s1 -- Equality
True
Prelude Data.Set> s1 == s2
False
Prelude Data.Set> 2 `member` s1 -- Membership
True
Prelude Data.Set> 10 `notMember` s1
True
Prelude Data.Set> size s1 -- Cardinality
4
Prelude Data.Set> insert 99 s1 -- Create a new set by inserting
fromList [1,2,3,4,99]
Prelude Data.Set> delete 3 s1 -- Create a new set by deleting
fromList [1,2,4]
