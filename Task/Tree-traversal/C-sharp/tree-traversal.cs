using System;
using System.Collections.Generic;
using System.Linq;

class Node
{
    int Value;
    Node Left;
    Node Right;

    Node(int value = default(int), Node left = default(Node), Node right = default(Node))
    {
        Value = value;
        Left = left;
        Right = right;
    }

    IEnumerable<int> Preorder()
    {
        yield return Value;
        if (Left != null)
            foreach (var value in Left.Preorder())
                yield return value;
        if (Right != null)
            foreach (var value in Right.Preorder())
                yield return value;
    }

    IEnumerable<int> Inorder()
    {
        if (Left != null)
            foreach (var value in Left.Inorder())
                yield return value;
        yield return Value;
        if (Right != null)
            foreach (var value in Right.Inorder())
                yield return value;
    }

    IEnumerable<int> Postorder()
    {
        if (Left != null)
            foreach (var value in Left.Postorder())
                yield return value;
        if (Right != null)
            foreach (var value in Right.Postorder())
                yield return value;
        yield return Value;
    }

    IEnumerable<int> LevelOrder()
    {
        var queue = new Queue<Node>();
        queue.Enqueue(this);
        while (queue.Any())
        {
            var node = queue.Dequeue();
            yield return node.Value;
            if (node.Left != null)
                queue.Enqueue(node.Left);
            if (node.Right != null)
                queue.Enqueue(node.Right);
        }
    }

    static void Main()
    {
        var tree = new Node(1, new Node(2, new Node(4, new Node(7)), new Node(5)), new Node(3, new Node(6, new Node(8), new Node(9))));
        foreach (var traversal in new Func<IEnumerable<int>>[] { tree.Preorder, tree.Inorder, tree.Postorder, tree.LevelOrder })
            Console.WriteLine("{0}:\t{1}", traversal.Method.Name, string.Join(" ", traversal()));
    }
}
