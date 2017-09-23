data = .array~of(1, 2, 3, "a", "b", "c", 2, 3, 4, "b", "c", "d")
uniqueData = .set~new~union(data)~makearray~sort

say "Unique elements are"
say
do item over uniqueData
   say item
end
