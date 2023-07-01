(de mapTree (Tree Fun)
   (set Tree (Fun (car Tree)))
   (and (cadr Tree) (mapTree @ Fun))
   (and (cddr Tree) (mapTree @ Fun)) )
