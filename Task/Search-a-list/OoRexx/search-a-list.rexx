-- ordered collections always return the first hit
a = .array~of(1,2,3,4,4,5)
say a~index(4)
a2 = .array~new(5,5)  -- multidimensional
a2[3,3] = 4
-- the returned index is an array of values
say a2~index(4)~makestring('line', ',')
-- Note, list indexes are assigned when an item is added and
-- are not tied to relative position
l = .list~of(1,2,3,4,4,5)
say l~index(4)
q = .queue~of(1,2,3,4,4,5)
say q~index(4)
-- directories are unordered, so it is
-- undertermined which one is returned
d = .directory~new
d["foo"] = 4
d["bar"] = 4
say d~index(4)
