module tree<Type>;

struct Tree
{
    Type value;
    Tree* left;
    Tree* right;
}

fn void Tree.replaceAll(Tree* a_tree, Type new_value)
{
    a_tree.value = new_value;
    if (a_tree.left) a_tree.left.replaceAll(new_value);
    if (a_tree.right) a_tree.right.replaceAll(new_value);
}
