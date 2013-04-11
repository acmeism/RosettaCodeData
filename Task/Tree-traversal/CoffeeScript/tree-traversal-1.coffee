# In this example, we don't encapsulate binary trees as objects; instead, we have a
# convention on how to store them as arrays, and we namespace the functions that
# operate on those data structures.
binary_tree =
  preorder: (tree, visit) ->
    return unless tree?
    [node, left, right] = tree
    visit node
    binary_tree.preorder left, visit
    binary_tree.preorder right, visit

  inorder: (tree, visit) ->
    return unless tree?
    [node, left, right] = tree
    binary_tree.inorder left, visit
    visit node
    binary_tree.inorder right, visit

  postorder: (tree, visit) ->
    return unless tree?
    [node, left, right] = tree
    binary_tree.postorder left, visit
    binary_tree.postorder right, visit
    visit node

  levelorder: (tree, visit) ->
    q = []
    q.push tree
    while q.length > 0
      t = q.shift()
      continue unless t?
      [node, left, right] = t
      visit node
      q.push left
      q.push right

do ->
  tree = [1, [2, [4, [7]], [5]], [3, [6, [8],[9]]]]
  test_walk = (walk_function_name) ->
    output = []
    binary_tree[walk_function_name] tree, output.push.bind(output)
    console.log walk_function_name, output.join ' '
  test_walk "preorder"
  test_walk "inorder"
  test_walk "postorder"
  test_walk "levelorder"
