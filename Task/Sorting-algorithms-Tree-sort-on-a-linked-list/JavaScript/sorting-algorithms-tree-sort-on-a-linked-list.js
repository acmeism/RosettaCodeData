class BinaryTree {
  constructor() {
    this.node = null;
    this.left_subtree = null;
    this.right_subtree = null;
  }

  insert(item) {
    if (this.node === null) {
      this.node = item;
      this.left_subtree = new BinaryTree();
      this.right_subtree = new BinaryTree();
    } else if (item < this.node) {
      this.left_subtree.insert(item);
    } else {
      this.right_subtree.insert(item);
    }
  }

  in_order(result) {
    if (this.node === null) {
      return;
    }
    this.left_subtree.in_order(result);
    result.push(this.node);
    this.right_subtree.in_order(result);
  }
}

function tree_sort(data) {
  const search_tree = new BinaryTree();
  for (const item of data) {
    search_tree.insert(item);
  }

  const sorted_list = [];
  search_tree.in_order(sorted_list);
  return sorted_list;
}

function print_list(data, fmt, sorted_flag) {
  let output = "";
  for (const item of data) {
    if (fmt === "%d") {
      output += item + " ";
    } else if (fmt === "%c") {
      output += item + " ";
    }
  }
  process.stdout.write(output);

  if (!sorted_flag) {
    process.stdout.write("-> ");
  } else {
    process.stdout.write("\n");
  }
}


function main() {
  const sl = [5, 3, 7, 9, 1];
  print_list(sl, "%d", false);
  const lls = tree_sort(sl);
  print_list(lls, "%d", true);

  const sl2 = ['d', 'c', 'e', 'b', 'a'];
  print_list(sl2, "%c", false);
  const lls2 = tree_sort(sl2);
  print_list(lls2, "%c", true);
}


main();
