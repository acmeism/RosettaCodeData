def task:
  # [node, left, right]
  def atree: [1, [2, [4, [7,[],[]],
                         []],
                     [5, [],[]]],

                 [3, [6, [8,[],[]],
                         [9,[],[]]],
                     []]] ;

  "preorder:   \( [atree|preorder ])",
  "inorder:    \( [atree|inorder  ])",
  "postorder:  \( [atree|postorder ])",
  "levelorder: \( [atree|levelorder])"
;

task
