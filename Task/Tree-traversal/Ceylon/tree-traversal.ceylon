import ceylon.collection {
	ArrayList
}

shared void run() {

	class Node(label, left = null, right = null) {
		shared Integer label;
		shared Node? left;
		shared Node? right;
		string => label.string;
	}
	
	void preorder(Node node) {
		process.write(node.string + " ");
		if(exists left = node.left) {
			preorder(left);
		}
		if(exists right = node.right) {
			preorder(right);
		}
	}
	
	void inorder(Node node) {
		if(exists left = node.left) {
			inorder(left);
		}
		process.write(node.string + " ");
		if(exists right = node.right) {
			inorder(right);
		}
	}
	
	void postorder(Node node) {
		if(exists left = node.left) {
			postorder(left);
		}
		if(exists right = node.right) {
			postorder(right);
		}
		process.write(node.string + " ");
	}
	
	void levelOrder(Node node) {
		value nodes = ArrayList<Node> {node};
		while(exists current = nodes.accept()) {
			process.write(current.string + " ");
			if(exists left = current.left) {
				nodes.offer(left);
			}
			if(exists right = current.right) {
				nodes.offer(right);
			}
		}
	}

	value tree = Node {
		label = 1;
		left = Node {
			label = 2;
			left = Node {
				label = 4;
				left = Node {
					label = 7;
				};
			};
			right = Node {
				label = 5;
			};
		};
		right = Node {
			label = 3;
			left = Node {
				label = 6;
				left = Node {
					label = 8;
				};
				right = Node {
					label = 9;
				};
			};
		};
	};
	
	process.write("preorder:   ");
	preorder(tree);
	print("");
	process.write("inorder:    ");
	inorder(tree);
	print("");
	process.write("postorder:  ");
	postorder(tree);
	print("");
	process.write("levelorder: ");
	levelOrder(tree);
	print("");
}
