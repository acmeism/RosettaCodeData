class BinaryTree<Data>(shared Data data, shared BinaryTree<Data>? left = null, shared BinaryTree<Data>? right = null) {
	
	shared BinaryTree<NewData> myMap<NewData>(NewData f(Data d)) =>
			BinaryTree {
				data = f(data);
				left = left?.myMap(f);
				right = right?.myMap(f);
			};
}

shared void run() {
	
	value tree1 = BinaryTree {
		data = 3;
		left = BinaryTree {
			data = 4;
		};
		right = BinaryTree {
			data = 5;
			left = BinaryTree {
				data = 6;
			};
		};
	};
	
	tree1.myMap(print);
	print("");
	
	value tree2 = tree1.myMap((x) => x * 333.33);
	tree2.myMap(print);
}
