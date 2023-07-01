(de lastIndex (Item Lst)
   (- (length Lst) (index Item (reverse Lst)) -1) )

(de findNeedle (Fun Sym Lst)
   (prinl Sym " " (or (Fun Sym Lst) "not found")) )

(let Lst '(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo)
   (findNeedle index 'Washington Lst)
   (findNeedle index 'Bush Lst)
   (findNeedle lastIndex 'Bush Lst) )
