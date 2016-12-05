empty_set = MapSet.new                  #=> #MapSet<[]>
set1 = MapSet.new(1..4)                 #=> #MapSet<[1, 2, 3, 4]>
MapSet.size(set1)                       #=> 4
MapSet.member?(set1,3)                  #=> true
MapSet.put(set1,9)                      #=> #MapSet<[1, 2, 3, 4, 9]>
set2 = MapSet.new([6,4,2,0])            #=> #MapSet<[0, 2, 4, 6]>
MapSet.union(set1,set2)                 #=> #MapSet<[0, 1, 2, 3, 4, 6]>
MapSet.intersection(set1,set2)          #=> #MapSet<[2, 4]>
MapSet.difference(set1,set2)            #=> #MapSet<[1, 3]>
MapSet.subset?(set1,set2)               #=> false
