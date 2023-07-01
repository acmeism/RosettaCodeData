class Program
{
    static void Main(string[] args)
    {
        BinaryTree<int> b = new BinaryTree<int>(6);
        b.left = new BinaryTree<int>(5);
        b.right = new BinaryTree<int>(7);

        BinaryTree<double> b2 = b.Map(x => x * 0.5);
    }
}
