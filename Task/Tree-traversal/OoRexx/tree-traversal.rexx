  one = .Node~new(1);
  two = .Node~new(2);
  three = .Node~new(3);
  four = .Node~new(4);
  five = .Node~new(5);
  six = .Node~new(6);
  seven = .Node~new(7);
  eight = .Node~new(8);
  nine = .Node~new(9);

  one~left = two
  one~right = three
  two~left = four
  two~right = five
  three~left = six
  four~left = seven
  six~left = eight
  six~right = nine

  out = .array~new
  .treetraverser~preorder(one, out);
  say "Preorder:  " out~toString("l", ", ")
  out~empty
  .treetraverser~inorder(one, out);
  say "Inorder:   " out~toString("l", ", ")
  out~empty
  .treetraverser~postorder(one, out);
  say "Postorder: " out~toString("l", ", ")
  out~empty
  .treetraverser~levelorder(one, out);
  say "Levelorder:" out~toString("l", ", ")


::class node
::method init
  expose left right data
  use strict arg data
  left = .nil
  right = .nil

::attribute left
::attribute right
::attribute data

::class treeTraverser
::method preorder class
  use arg node, out
  if node \== .nil then do
      out~append(node~data)
      self~preorder(node~left, out)
      self~preorder(node~right, out)
  end

::method inorder class
  use arg node, out
  if node \== .nil then do
      self~inorder(node~left, out)
      out~append(node~data)
      self~inorder(node~right, out)
  end

::method postorder class
  use arg node, out
  if node \== .nil then do
      self~postorder(node~left, out)
      self~postorder(node~right, out)
      out~append(node~data)
  end

::method levelorder class
  use arg node, out

  if node == .nil then return
  nodequeue = .queue~new
  nodequeue~queue(node)
  loop while \nodequeue~isEmpty
      next = nodequeue~pull
      out~append(next~data)
      if next~left \= .nil then
          nodequeue~queue(next~left)
      if next~right \= .nil then
          nodequeue~queue(next~right)
  end
