using System;

class BinaryTree<T>
{
    public T value;
    public BinaryTree<T> left;
    public BinaryTree<T> right;

    public BinaryTree(T value)
    {
        this.value = value;
    }

    public BinaryTree<U> Map<U>(Func<T, U> f)
    {
        BinaryTree<U> tree = new BinaryTree<U>(f(this.value));
        if (this.left != null)
        {
            tree.left = this.left.Map(f);
        }
        if (this.right != null)
        {
            tree.right = this.right.Map(f);
        }
        return tree;
    }
}
