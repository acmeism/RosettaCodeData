using System;

public static class VisualizeTree
{
    public static void Main() {
        "A".t(
            "B0".t(
                "C1",
                "C2".t(
                    "D".t("E1", "E2", "E3")),
                "C3".t(
                    "F1",
                    "F2",
                    "F3".t("G"),
                    "F4".t("H1", "H2"))),
            "B1".t(
                "K1",
                "K2".t(
                    "L1".t("M"),
                    "L2",
                    "L3"),
                "K3")
        ).Print();
    }

    private static Tree t(this string value, params Tree[] children) => new Tree(value, children);

    private static void Print(this Tree tree) => tree.Print(true, "");

    private static void Print(this Tree tree, bool last, string prefix) {
        (string current, string next) = last
            ? (prefix + "└─" + tree.Value, prefix + "  ")
            : (prefix + "├─" + tree.Value, prefix + "| ");
        Console.WriteLine(current[2..]);
        for (int c = 0; c < tree.Children.Length; c++) {
            tree.Children[c].Print(c == tree.Children.Length - 1, next);
        }
    }

    class Tree
    {
        public Tree(string value, params Tree[] children) => (Value, Children) = (value, children);
        public static implicit operator Tree(string value) => new Tree(value);
        public string Value { get; }
        public Tree[] Children { get; }
    }

}
