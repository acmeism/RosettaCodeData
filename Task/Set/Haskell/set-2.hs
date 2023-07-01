Prelude> import Data.List
Prelude Data.List> let s3 = nub [1,2,3,4,3] -- Remove duplicates from list
Prelude Data.List> s3
[1,2,3,4]
Prelude Data.List> let s4 = [3,4,5,6]
Prelude Data.List> union s3 s4 -- Union
[1,2,3,4,5,6]
Prelude Data.List> intersect s3 s4 -- Intersection
[3,4]
Prelude Data.List> s3 \\ s4 -- Difference
[1,2]
Prelude Data.List> 42 : s3 -- Return new list with element inserted at the beginning
[42,1,2,3,4]
Prelude Data.List> delete 3 s3 -- Return new list with first occurrence of element removed
[1,2,4]
