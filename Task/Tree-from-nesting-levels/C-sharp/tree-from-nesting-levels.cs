public static class TreeFromNestingLevels
{
    public static void Main()
    {
        List<int[]> tests = [[], [1,2,4], [3,1,3,1], [1,2,3,1], [3,2,1,3], [3,3,3,1,1,3,3,3]];
        Console.WriteLine($"{"Input",24} -> {"Nested",-32} -> Round-trip");
        foreach (var test in tests) {
            var tree = BuildTree(test);
            string input = $"[{string.Join(", ", test)}]";
            string roundTrip = $"[{string.Join(", ", tree.ToList())}]";
            Console.WriteLine($"{input,24} -> {tree,-32} -> {roundTrip}");
        }
    }

    private static Tree BuildTree(int[] levels)
    {
        Tree root = new(0);
        Tree current = root;
        foreach (int level in levels) {
            while (current.Level > level) current = current.Parent;
            current = current.Parent.Add(level);
        }
        return root;
    }

    private class Tree
    {
        public int Level { get; }
        public Tree Parent { get; }
        private readonly List<Tree> children = [];

        public Tree(int level, Tree? parent = null)
        {
            Level = level;
            Parent = parent ?? this;
        }

        public Tree Add(int level)
        {
            if (Level == level) return this;
            Tree tree = new(Level + 1, this);
            children.Add(tree);
            return tree.Add(level);
        }

        public override string ToString() => children.Count == 0
            ? (Level == 0 ? "[]" : $"{Level}")
            : $"[{string.Join(", ", children.Select(c => c.ToString()))}]";

        public List<int> ToList()
        {
            List<int> list = [];
            ToList(this, list);
            return list;
        }

        private static void ToList(Tree tree, List<int> list)
        {
            if (tree.children.Count == 0) {
                if (tree.Level > 0) list.Add(tree.Level);
            } else {
                foreach (Tree child in tree.children) {
                    ToList(child, list);
                }
            }
        }

    }

}
