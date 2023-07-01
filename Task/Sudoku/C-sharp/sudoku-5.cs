using System;
using System.Collections.Generic;
using System.Text;
using static System.Linq.Enumerable;

public class Sudoku
{
    public static void Main2() {
        string puzzle = "....7.94.....9...53....5.7...74..1..463...........7.8.8........7......28.5.26....";
        string solution = new Sudoku().Solutions(puzzle).FirstOrDefault() ?? puzzle;
        Print(puzzle, solution);
    }

    private DLX dlx;

    public void Build() {
        const int rows = 9 * 9 * 9, columns = 4 * 9 * 9;
        dlx = new DLX(rows, columns);
        for (int i = 0; i < columns; i++) dlx.AddHeader();

        for (int cell = 0, row = 0; row < 9; row++) {
            for (int column = 0; column < 9; column++) {
                int box = row / 3 * 3 + column / 3;
                for (int digit = 0; digit < 9; digit++) {
                    dlx.AddRow(cell, 81 + row * 9 + digit, 2 * 81 + column * 9 + digit, 3 * 81 + box * 9 + digit);
                }
                cell++;
            }
        }
    }

    public IEnumerable<string> Solutions(string puzzle) {
        if (puzzle == null) throw new ArgumentNullException(nameof(puzzle));
        if (puzzle.Length != 81) throw new ArgumentException("The input is not of the correct length.");
        if (dlx == null) Build();

        for (int i = 0; i < puzzle.Length; i++) {
            if (puzzle[i] == '0' || puzzle[i] == '.') continue;
            if (puzzle[i] < '1' && puzzle[i] > '9') throw new ArgumentException($"Input contains an invalid character: ({puzzle[i]})");
            int digit = puzzle[i] - '0' - 1;
            dlx.Give(i * 9 + digit);
        }
        return Iterator();

        IEnumerable<string> Iterator() {
            var sb = new StringBuilder(new string('.', 81));
            foreach (int[] rows in dlx.Solutions()) {
                foreach (int r in rows) {
                    sb[r / 81 * 9 + r / 9 % 9] = (char)(r % 9 + '1');
                }
                yield return sb.ToString();
            }
        }
    }

    static void Print(string left, string right) {
        foreach (string line in GetPrintLines(left).Zip(GetPrintLines(right), (l, r) => l + "\t" + r)) {
            Console.WriteLine(line);
        }

        IEnumerable<string> GetPrintLines(string s) {
            int r = 0;
            foreach (string row in s.Cut(9)) {
                yield return r == 0
                    ? "╔═══╤═══╤═══╦═══╤═══╤═══╦═══╤═══╤═══╗"
                    : r % 3 == 0
                    ? "╠═══╪═══╪═══╬═══╪═══╪═══╬═══╪═══╪═══╣"
                    : "╟───┼───┼───╫───┼───┼───╫───┼───┼───╢";
                yield return "║ " + row.Cut(3).Select(segment => segment.DelimitWith(" │ ")).DelimitWith(" ║ ") + " ║";
                r++;
            }
            yield return "╚═══╧═══╧═══╩═══╧═══╧═══╩═══╧═══╧═══╝";
        }
    }

}

public class DLX //Some functionality elided
{
    private readonly Header root = new Header(null, null) { Size = int.MaxValue };
    private readonly List<Header> columns;
    private readonly List<Node> rows;
    private readonly Stack<Node> solutionNodes = new Stack<Node>();
    private int initial = 0;

    public DLX(int rowCapacity, int columnCapacity) {
        columns = new List<Header>(columnCapacity);
        rows = new List<Node>(rowCapacity);
    }

    public void AddHeader() {
        Header h = new Header(root.Left, root);
        h.AttachLeftRight();
        columns.Add(h);
    }

    public void AddRow(params int[] newRow) {
        Node first = null;
        if (newRow != null) {
            for (int i = 0; i < newRow.Length; i++) {
                if (newRow[i] < 0) continue;
                if (first == null) first = AddNode(rows.Count, newRow[i]);
                else AddNode(first, newRow[i]);
            }
        }
        rows.Add(first);
    }

    private Node AddNode(int row, int column) {
        Node n = new Node(null, null, columns[column].Up, columns[column], columns[column], row);
        n.AttachUpDown();
        n.Head.Size++;
        return n;
    }

    private void AddNode(Node firstNode, int column) {
        Node n = new Node(firstNode.Left, firstNode, columns[column].Up, columns[column], columns[column], firstNode.Row);
        n.AttachLeftRight();
        n.AttachUpDown();
        n.Head.Size++;
    }

    public void Give(int row) {
        solutionNodes.Push(rows[row]);
        CoverMatrix(rows[row]);
        initial++;
    }

    public IEnumerable<int[]> Solutions() {
        try {
            Node node = ChooseSmallestColumn().Down;
            do {
                if (node == node.Head) {
                    if (node == root) {
                        yield return solutionNodes.Select(n => n.Row).ToArray();
                    }
                    if (solutionNodes.Count > initial) {
                        node = solutionNodes.Pop();
                        UncoverMatrix(node);
                        node = node.Down;
                    }
                } else {
                    solutionNodes.Push(node);
                    CoverMatrix(node);
                    node = ChooseSmallestColumn().Down;
                }
            } while(solutionNodes.Count > initial || node != node.Head);
        } finally {
            Restore();
        }
    }

    private void Restore() {
        while (solutionNodes.Count > 0) UncoverMatrix(solutionNodes.Pop());
        initial = 0;
    }

    private Header ChooseSmallestColumn() {
        Header traveller = root, choice = root;
        do {
            traveller = (Header)traveller.Right;
            if (traveller.Size < choice.Size) choice = traveller;
        } while (traveller != root && choice.Size > 0);
        return choice;
    }

    private void CoverRow(Node row) {
        Node traveller = row.Right;
        while (traveller != row) {
            traveller.DetachUpDown();
            traveller.Head.Size--;
            traveller = traveller.Right;
        }
    }

    private void UncoverRow(Node row) {
        Node traveller = row.Left;
        while (traveller != row) {
            traveller.AttachUpDown();
            traveller.Head.Size++;
            traveller = traveller.Left;
        }
    }

    private void CoverColumn(Header column) {
        column.DetachLeftRight();
        Node traveller = column.Down;
        while (traveller != column) {
            CoverRow(traveller);
            traveller = traveller.Down;
        }
    }

    private void UncoverColumn(Header column) {
        Node traveller = column.Up;
        while (traveller != column) {
            UncoverRow(traveller);
            traveller = traveller.Up;
        }
        column.AttachLeftRight();
    }

    private void CoverMatrix(Node node) {
        Node traveller = node;
        do {
            CoverColumn(traveller.Head);
            traveller = traveller.Right;
        } while (traveller != node);
    }

    private void UncoverMatrix(Node node) {
        Node traveller = node;
        do {
            traveller = traveller.Left;
            UncoverColumn(traveller.Head);
        } while (traveller != node);
    }

    private class Node
    {
        public Node(Node left, Node right, Node up, Node down, Header head, int row) {
            Left = left ?? this;
            Right = right ?? this;
            Up = up ?? this;
            Down = down ?? this;
            Head = head ?? this as Header;
            Row = row;
        }

        public Node Left   { get; set; }
        public Node Right  { get; set; }
        public Node Up     { get; set; }
        public Node Down   { get; set; }
        public Header Head { get; }
        public int Row     { get; }

        public void AttachLeftRight() {
            this.Left.Right = this;
            this.Right.Left = this;
        }

        public void AttachUpDown() {
            this.Up.Down = this;
            this.Down.Up = this;
        }

        public void DetachLeftRight() {
            this.Left.Right = this.Right;
            this.Right.Left = this.Left;
        }

        public void DetachUpDown() {
            this.Up.Down = this.Down;
            this.Down.Up = this.Up;
        }

    }

    private class Header : Node
    {
        public Header(Node left, Node right) : base(left, right, null, null, null, -1) { }

        public int Size { get; set; }
    }

}

static class Extensions
{
    public static IEnumerable<string> Cut(this string input, int length)
    {
        for (int cursor = 0; cursor < input.Length; cursor += length) {
            if (cursor + length > input.Length) yield return input.Substring(cursor);
            else yield return input.Substring(cursor, length);
        }
    }

    public static string DelimitWith<T>(this IEnumerable<T> source, string separator) => string.Join(separator, source);
}
