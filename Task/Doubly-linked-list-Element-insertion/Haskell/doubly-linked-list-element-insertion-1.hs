insert _  Leaf            = Leaf
insert nv l@(Node pl v r) = (\(Node c _ _) -> c) new
    where new   = updateLeft left . updateRight right $ Node l nv r
          left  = Node pl v new
          right = case r of
                      Leaf       -> Leaf
                      Node _ v r -> Node new v r
