| tree |
tree := (Node data: 1)
		left: ((Node data: 2)
			left: ((Node data: 4)
				left: (Node data: 7));
			right: (Node data: 5));
		right: ((Node data: 3)
			left: ((Node data: 6)
				left: (Node data: 8);
				right: (Node data: 9))).
tree traverse: PreOrder do: [:node | Transcript print: node data; space].
Transcript cr.
tree traverse: InOrder do: [:node | Transcript print: node data; space].
Transcript cr.
tree traverse: PostOrder do: [:node | Transcript print: node data; space].
Transcript cr.
tree traverse: LevelOrder do: [:node | Transcript print: node data; space].
Transcript cr.
