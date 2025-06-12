module tree {Type};

struct Tree
{
    Type value;
    Tree* left;
    Tree* right;
}

fn void Tree.replace_all(&self, Type new_value)
{
    self.value = new_value;
    if (self.left) self.left.replace_all(new_value);
    if (self.right) self.right.replace_all(new_value);
}
