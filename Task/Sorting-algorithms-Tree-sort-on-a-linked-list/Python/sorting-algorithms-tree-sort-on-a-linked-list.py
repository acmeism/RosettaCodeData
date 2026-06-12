class BinaryTree:
    def __init__(self):
        self.node = None
        self.left_subtree = None
        self.right_subtree = None

    def insert(self, item):
        if self.node is None:
            self.node = item
            self.left_subtree = BinaryTree()
            self.right_subtree = BinaryTree()
        elif item < self.node:
            self.left_subtree.insert(item)
        else:
            self.right_subtree.insert(item)

    def in_order(self, result):
        if self.node is None:
            return
        self.left_subtree.in_order(result)
        result.append(self.node)
        self.right_subtree.in_order(result)


def tree_sort(data):
    search_tree = BinaryTree()
    for item in data:
        search_tree.insert(item)

    sorted_list = []
    search_tree.in_order(sorted_list)
    return sorted_list


def print_list(data, fmt, sorted_flag):
    for item in data:
        print(fmt % item, end=" ")
    if not sorted_flag:
        print("-> ", end="")
    else:
        print()


def main():
    sl = [5, 3, 7, 9, 1]
    print_list(sl, "%d", False)
    lls = tree_sort(sl)
    print_list(lls, "%d", True)

    sl2 = ['d', 'c', 'e', 'b', 'a']
    print_list(sl2, "%c", False)
    lls2 = tree_sort(sl2)
    print_list(lls2, "%c", True)


if __name__ == "__main__":
    main()
