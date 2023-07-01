tree: [1 [2 [4 [7 [] []] []] [5 [] []]] [3 [6 [8 [] []] [9 [] []]] []]]
; "compacted" version
tree: [1 [2 [4 [7  ] ] [5  ]] [3 [6 [8  ] [9  ]] ]]

visit: func [tree [block!]][prin rejoin [first tree " "]]
left: :second
right: :third

preorder: func [tree [block!]][
	if not empty? tree [visit tree]
	attempt [preorder left tree]
	attempt [preorder right tree]
]
prin "preorder:    " preorder tree
print ""

inorder: func [tree [block!]][
	attempt [inorder left tree]
	if not empty? tree [visit tree]
	attempt [inorder right tree]
]
prin "inorder:     " inorder tree
print ""

postorder: func [tree [block!]][
	attempt [postorder left tree]
	attempt [postorder right tree]
	if not empty? tree [visit tree]
]
prin "postorder:   " postorder tree
print ""

queue: []
enqueue: func [tree [block!]][append/only queue tree]
dequeue: func [queue [block!]][take queue]
level-order: func [tree [block!]][
	clear head queue
	queue: enqueue tree
	while [not empty? queue] [
		tree: dequeue queue
		if not empty? tree [visit tree]
		attempt [enqueue left tree]
		attempt [enqueue right tree]
	]
]
prin "level-order: " level-order tree
