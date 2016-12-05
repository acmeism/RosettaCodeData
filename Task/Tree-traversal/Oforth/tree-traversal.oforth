Object Class new: Tree(v, l, r)

Tree method: initialize(v, l, r)  v := v l := l r := r ;
Tree method: v   @v ;
Tree method: l   @l ;
Tree method: r   @r ;

Tree method: preOrder(f)
   @v f perform
   @l ifNotNull: [ @l preOrder(f) ]
   @r ifNotNull: [ @r preOrder(f) ] ;

Tree method: inOrder(f)
   @l ifNotNull: [ @l inOrder(f) ]
   @v f perform
   @r ifNotNull: [ @r inOrder(f) ] ;

Tree method: postOrder(f)
   @l ifNotNull: [ @l postOrder(f) ]
   @r ifNotNull: [ @r postOrder(f) ]
   @v f perform ;

Tree method: levelOrder(f)
| c n |
   Channel new self over send drop ->c
   while(c notEmpty) [
      c receive ->n
      n v f perform
      n l dup ifNotNull: [ c send ] drop
      n r dup ifNotNull: [ c send ] drop
      ] ;
