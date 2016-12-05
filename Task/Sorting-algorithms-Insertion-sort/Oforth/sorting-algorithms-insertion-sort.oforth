: insertionSort(a)
| l i j v |
   a asListBuffer ->l
   2 l size for: i [
      l at(i) ->v
      i 1- ->j
      while(j) [
         l at(j) dup v <= ifTrue: [ drop break ]
         j 1+ swap l put
         j 1- ->j
         ]
      l put(j 1 +, v)
      ]
   l ;
