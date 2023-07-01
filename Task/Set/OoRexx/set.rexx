-- Set creation
-- Using the OF method
s1 = .set~of(1, 2, 3, 4, 5, 6)
-- Explicit addition of individual items
s2 = .set~new
s2~put(2)
s2~put(4)
s2~put(6)
-- group addition
s3 = .set~new
s3~putall(.array~of(1, 3, 5))
-- Test m ? S -- "m is an element in set S"
say s1~hasindex(1) s3~hasindex(2)  -- "1 0", which is "true" and "false"
--    A ? B -- union; a set of all elements either in set A or in set B.
s4 = s2~union(s3)   -- {1, 2, 3, 4, 5, 6}
Call show 's4',s4
--    A ? B -- intersection; a set of all elements in both set A and set B.
s5 = s1~intersection(s2)   -- {2, 4, 6}
Call show 's5',s5
--    A ? B -- difference; a set of all elements in set A, except those in set B.
s6 = s1~difference(s2)   -- {1, 3, 5}
Call show 's6',s6
--    A ? B -- subset; true if every element in set A is also in set B.
say s1~subset(s2) s2~subset(s1) --  "0 1"
--    A = B -- equality; true if every element of set A is in set B and vice-versa.
-- No direct equivalence method, but the XOR method can be used to determine this
say s1~xor(s4)~isempty   -- true
Exit
show: Procedure
  Use Arg set_name,set
  Say set_name':' set~makearray~makestring((LINE),',')
  return
