(de preorder (Node Fun)
   (when Node
      (Fun (car Node))
      (preorder (cadr Node) Fun)
      (preorder (caddr Node) Fun) ) )

(de inorder (Node Fun)
   (when Node
      (inorder (cadr Node) Fun)
      (Fun (car Node))
      (inorder (caddr Node) Fun) ) )

(de postorder (Node Fun)
   (when Node
      (postorder (cadr Node) Fun)
      (postorder (caddr Node) Fun)
      (Fun (car Node)) ) )

(de level-order (Node Fun)
   (for (Q (circ Node)  Q)
      (let N (fifo 'Q)
         (Fun (car N))
         (and (cadr N) (fifo 'Q @))
         (and (caddr N) (fifo 'Q @)) ) ) )

(setq *Tree
   (1
      (2 (4 (7)) (5))
      (3 (6 (8) (9))) ) )

(for Order '(preorder inorder postorder level-order)
   (prin (align -13 (pack Order ":")))
   (Order *Tree printsp)
   (prinl) )
