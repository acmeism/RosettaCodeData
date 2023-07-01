using System;

class Tree
{
    public static void Main() {
        Tree tree = Tree.E;
        for (int i = 1; i <= 16; i++) {
            tree = tree.Insert(i);
        }
        tree.Print();
    }

    private const bool B = false, R = true;
    public static readonly Tree E = new Tree(B, null, 0, null);

    private Tree(bool c, Tree? l, int v, Tree? r) => (IsRed, Left, Value, Right) = (c, l ?? this, v, r ?? this);

    public bool IsRed { get; private set; }
    public int Value { get; }
    public Tree Left { get; }
    public Tree Right { get; }

    public static implicit operator Tree((bool c, Tree l, int v, Tree r) t) => new Tree(t.c, t.l, t.v, t.r);
    public void Deconstruct(out bool c, out Tree l, out int v, out Tree r) => (c, l, v, r) = (IsRed, Left, Value, Right);
    public override string ToString() => this == E ? "[]" : $"[{(IsRed ? 'R' : 'B')}{Value}]";
    public Tree Insert(int x) => Ins(x).MakeBlack();
    private Tree MakeBlack() { IsRed = false; return this; }

    public void Print(int indent = 0) {
        if (this != E) Right.Print(indent + 1);
        Console.WriteLine(new string(' ', indent * 4) + ToString());
        if (this != E) Left.Print(indent + 1);
    }

    private Tree Ins(int x) => Math.Sign(x.CompareTo(Value)) switch {
         _ when this == E => (R, E, x, E),
        -1 => new Tree(IsRed, Left.Ins(x) , Value, Right).Balance(),
         1 => new Tree(IsRed, Left , Value, Right.Ins(x)).Balance(),
         _ => this
    };

    private Tree Balance() => this switch {
        (B, (R, (R, var a, var x, var b), var y, var c), var z, var d) => (R, (B, a, x, b), y, (B, c, z, d)),
        (B, (R, var a, var x, (R, var b, var y, var c)), var z, var d) => (R, (B, a, x, b), y, (B, c, z, d)),
        (B, var a, var x, (R, (R, var b, var y, var c), var z, var d)) => (R, (B, a, x, b), y, (B, c, z, d)),
        (B, var a, var x, (R, var b, var y, (R, var c, var z, var d))) => (R, (B, a, x, b), y, (B, c, z, d)),
        _ => this
    };
}
