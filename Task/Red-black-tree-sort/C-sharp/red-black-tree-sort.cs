using System;

// Node class represents a node in the Red-Black Tree
public class Node
{
    public int Val { get; set; }
    public Node Parent { get; set; }
    public Node Left { get; set; }
    public Node Right { get; set; }
    public int Color { get; set; } // 1 for Red, 0 for Black

    public Node(int val)
    {
        this.Val = val;
        this.Parent = null;
        this.Left = null;
        this.Right = null;
        this.Color = 1; // Red
    }

    // Constructor for null node
    public Node()
    {
        this.Val = 0;
        this.Color = 0; // Black
        this.Left = null;
        this.Right = null;
        this.Parent = null;
    }
}

// RBTree class represents a Red-Black Tree
public class RBTree
{
    private Node nullNode;
    private Node root;

    // Constructor creates a new Red-Black Tree
    public RBTree()
    {
        this.nullNode = new Node(); // Creates null node with default values
        this.root = this.nullNode;
    }

    // Creates a new node with the given value
    private Node NewNode(int val)
    {
        Node node = new Node(val);
        node.Left = this.nullNode;
        node.Right = this.nullNode;
        return node;
    }

    // Inserts a new node with the given key
    public void InsertNode(int key)
    {
        Node node = NewNode(key);
        node.Parent = null;
        node.Left = this.nullNode;
        node.Right = this.nullNode;
        node.Color = 1; // Red

        Node y = null;
        Node x = this.root;

        while (x != this.nullNode)
        {
            y = x;
            if (node.Val < x.Val)
            {
                x = x.Left;
            }
            else
            {
                x = x.Right;
            }
        }

        node.Parent = y;
        if (y == null)
        {
            this.root = node;
        }
        else if (node.Val < y.Val)
        {
            y.Left = node;
        }
        else
        {
            y.Right = node;
        }

        if (node.Parent == null)
        {
            node.Color = 0; // Black
            return;
        }

        if (node.Parent.Parent == null)
        {
            return;
        }

        FixInsert(node);
    }

    // Finds the node with the minimum value in the subtree rooted at node
    private Node Minimum(Node node)
    {
        while (node.Left != this.nullNode)
        {
            node = node.Left;
        }
        return node;
    }

    // Performs a left rotation on the given node
    private void LeftRotate(Node x)
    {
        Node y = x.Right;
        x.Right = y.Left;
        if (y.Left != this.nullNode)
        {
            y.Left.Parent = x;
        }

        y.Parent = x.Parent;
        if (x.Parent == null)
        {
            this.root = y;
        }
        else if (x == x.Parent.Left)
        {
            x.Parent.Left = y;
        }
        else
        {
            x.Parent.Right = y;
        }
        y.Left = x;
        x.Parent = y;
    }

    // Performs a right rotation on the given node
    private void RightRotate(Node x)
    {
        Node y = x.Left;
        x.Left = y.Right;
        if (y.Right != this.nullNode)
        {
            y.Right.Parent = x;
        }

        y.Parent = x.Parent;
        if (x.Parent == null)
        {
            this.root = y;
        }
        else if (x == x.Parent.Right)
        {
            x.Parent.Right = y;
        }
        else
        {
            x.Parent.Left = y;
        }
        y.Right = x;
        x.Parent = y;
    }

    // Fixes the Red-Black Tree after insertion
    private void FixInsert(Node k)
    {
        while (k.Parent.Color == 1)
        {
            if (k.Parent == k.Parent.Parent.Right)
            {
                Node u = k.Parent.Parent.Left;
                if (u.Color == 1)
                {
                    u.Color = 0;
                    k.Parent.Color = 0;
                    k.Parent.Parent.Color = 1;
                    k = k.Parent.Parent;
                }
                else
                {
                    if (k == k.Parent.Left)
                    {
                        k = k.Parent;
                        RightRotate(k);
                    }
                    k.Parent.Color = 0;
                    k.Parent.Parent.Color = 1;
                    LeftRotate(k.Parent.Parent);
                }
            }
            else
            {
                Node u = k.Parent.Parent.Right;
                if (u.Color == 1)
                {
                    u.Color = 0;
                    k.Parent.Color = 0;
                    k.Parent.Parent.Color = 1;
                    k = k.Parent.Parent;
                }
                else
                {
                    if (k == k.Parent.Right)
                    {
                        k = k.Parent;
                        LeftRotate(k);
                    }
                    k.Parent.Color = 0;
                    k.Parent.Parent.Color = 1;
                    RightRotate(k.Parent.Parent);
                }
            }
            if (k == this.root)
            {
                break;
            }
        }
        this.root.Color = 0;
    }

    // Fixes the Red-Black Tree after deletion
    private void FixDelete(Node x)
    {
        while (x != this.root && x.Color == 0)
        {
            if (x == x.Parent.Left)
            {
                Node s = x.Parent.Right;
                if (s.Color == 1)
                {
                    s.Color = 0;
                    x.Parent.Color = 1;
                    LeftRotate(x.Parent);
                    s = x.Parent.Right;
                }

                if (s.Left.Color == 0 && s.Right.Color == 0)
                {
                    s.Color = 1;
                    x = x.Parent;
                }
                else
                {
                    if (s.Right.Color == 0)
                    {
                        s.Left.Color = 0;
                        s.Color = 1;
                        RightRotate(s);
                        s = x.Parent.Right;
                    }

                    s.Color = x.Parent.Color;
                    x.Parent.Color = 0;
                    s.Right.Color = 0;
                    LeftRotate(x.Parent);
                    x = this.root;
                }
            }
            else
            {
                Node s = x.Parent.Left;
                if (s.Color == 1)
                {
                    s.Color = 0;
                    x.Parent.Color = 1;
                    RightRotate(x.Parent);
                    s = x.Parent.Left;
                }

                if (s.Right.Color == 0 && s.Left.Color == 0)
                {
                    s.Color = 1;
                    x = x.Parent;
                }
                else
                {
                    if (s.Left.Color == 0)
                    {
                        s.Right.Color = 0;
                        s.Color = 1;
                        LeftRotate(s);
                        s = x.Parent.Left;
                    }

                    s.Color = x.Parent.Color;
                    x.Parent.Color = 0;
                    s.Left.Color = 0;
                    RightRotate(x.Parent);
                    x = this.root;
                }
            }
        }
        x.Color = 0;
    }

    // Replaces one subtree with another
    private void RbTransplant(Node u, Node v)
    {
        if (u.Parent == null)
        {
            this.root = v;
        }
        else if (u == u.Parent.Left)
        {
            u.Parent.Left = v;
        }
        else
        {
            u.Parent.Right = v;
        }
        v.Parent = u.Parent;
    }

    // Helper function for deleteNode
    private void DeleteNodeHelper(Node node, int key)
    {
        Node z = this.nullNode;
        Node temp = node;

        while (temp != this.nullNode)
        {
            if (temp.Val == key)
            {
                z = temp;
            }

            if (temp.Val <= key)
            {
                temp = temp.Right;
            }
            else
            {
                temp = temp.Left;
            }
        }

        if (z == this.nullNode)
        {
            Console.WriteLine("Value not present in Tree !!");
            return;
        }

        Node y = z;
        int yOriginalColor = y.Color;
        Node x;

        if (z.Left == this.nullNode)
        {
            x = z.Right;
            RbTransplant(z, z.Right);
        }
        else if (z.Right == this.nullNode)
        {
            x = z.Left;
            RbTransplant(z, z.Left);
        }
        else
        {
            y = Minimum(z.Right);
            yOriginalColor = y.Color;
            x = y.Right;
            if (y.Parent == z)
            {
                x.Parent = y;
            }
            else
            {
                RbTransplant(y, y.Right);
                y.Right = z.Right;
                y.Right.Parent = y;
            }

            RbTransplant(z, y);
            y.Left = z.Left;
            y.Left.Parent = y;
            y.Color = z.Color;
        }

        if (yOriginalColor == 0)
        {
            FixDelete(x);
        }
    }

    // Deletes a node with the given value
    public void DeleteNode(int val)
    {
        DeleteNodeHelper(this.root, val);
    }

    // Recursively prints the tree
    private void PrintCall(Node node, string indent, bool last)
    {
        if (node != this.nullNode)
        {
            Console.Write(indent);
            if (last)
            {
                Console.Write("R----");
                indent += "     ";
            }
            else
            {
                Console.Write("L----");
                indent += "|    ";
            }

            string sColor = (node.Color == 1) ? "RED" : "BLACK";
            Console.WriteLine($"{node.Val}({sColor})");
            PrintCall(node.Left, indent, false);
            PrintCall(node.Right, indent, true);
        }
    }

    // Prints the entire tree
    public void PrintTree()
    {
        PrintCall(this.root, "", true);
    }

    // Main method for testing
    public static void Main(string[] args)
    {
        RBTree bst = new RBTree();

        Console.WriteLine("State of the tree after inserting the 30 keys:");
        for (int x = 1; x < 30; x++)
        {
            bst.InsertNode(x);
        }
        bst.PrintTree();

        Console.WriteLine("\nState of the tree after deleting the 15 keys:");
        for (int x = 1; x < 15; x++)
        {
            bst.DeleteNode(x);
        }
        bst.PrintTree();
    }
}

