using System;

class BinaryTree<T>
{
    public BinaryTree<T> Left { get; }
    public BinaryTree<T> Right { get; }
    public T Value { get; }

    public BinaryTree(T value, BinaryTree<T> left = null, BinaryTree<T> right = null)
    {
        this.Value = value;
        this.Left = left;
        this.Right = right;
    }

    public BinaryTree<U> Map<U>(Func<T, U> f)
    {
        return new BinaryTree<U>(f(this.Value), this.Left?.Map(f), this.Right?.Map(f));
    }

    public override string ToString()
    {
        var sb = new System.Text.StringBuilder();
        this.ToString(sb, 0);
        return sb.ToString();
    }

    private void ToString(System.Text.StringBuilder sb, int depth)
    {
        sb.Append(new string('\t', depth));
        sb.AppendLine(this.Value?.ToString());
        this.Left?.ToString(sb, depth + 1);
        this.Right?.ToString(sb, depth + 1);
    }
}

static class Program
{
    static void Main()
    {
        var b = new BinaryTree<int>(6, new BinaryTree<int>(5), new BinaryTree<int>(7));

        BinaryTree<double> b2 = b.Map(x => x * 0.5);

        Console.WriteLine(b);
        Console.WriteLine(b2);
    }
}
