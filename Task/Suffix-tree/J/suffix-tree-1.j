classify=: {.@> </. ]

build_tree=:3 :0
  tree=. ,:_;_;''
  if. 0=#y do. tree return.end.
  if. 1=#y do. tree,(#;y);0;y return.end.
  for_box.classify y do.
    char=. {.>{.>box
    subtree=. }.build_tree }.each>box
    ndx=.I.0=1&{::"1 subtree
    n=.#tree
    if. 1=#ndx do.
      counts=. 1 + 0&{::"1 subtree
      parents=. (n-1) (+*]&*) 1&{::"1 subtree
      edges=. (ndx}~ <@(char,ndx&{::)) 2&{"1 subtree
      tree=. tree, counts;"0 1 parents;"0 edges
    else.
      tree=. tree,(__;0;,char),(1;n;0) + ::]&.>"1 subtree
    end.
  end.
)

suffix_tree=:3 :0
  assert. -.({:e.}:)y
  tree=. B=:|:build_tree <\. y
  ((1+#y)-each {.tree),}.tree
)
