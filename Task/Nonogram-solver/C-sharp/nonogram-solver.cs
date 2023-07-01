using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class NonogramSolver
{
    public static void Main2() {
        foreach (var (x, y) in new [] {
            ("C BA CB BB F AE F A B", "AB CA AE GA E C D C"),
            ("F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
                "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA"),
            ("CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
                "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF AAAAD BDG CEF CBDB BBB FC"),
            ("E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
                "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM")
            })
        {
            Solve(x, y);
            Console.WriteLine();
        }
    }

    static void Solve(string rowLetters, string columnLetters) {
        var r = rowLetters.Split(" ").Select(row => row.Select(s => s - 'A' + 1).ToArray()).ToArray();
        var c = columnLetters.Split(" ").Select(column => column.Select(s => s - 'A' + 1).ToArray()).ToArray();
        Solve(r, c);
    }

    static void Solve(int[][] rowRuns, int[][] columnRuns) {
        int len = columnRuns.Length;
        var rows = rowRuns.Select(row => Generate(len, row)).ToList();
        var columns = columnRuns.Select(column => Generate(rowRuns.Length, column)).ToList();
        Reduce(rows, columns);
        foreach (var list in rows) {
            if (list.Count != 1) Console.WriteLine(Repeat('?', len).Spaced());
            else Console.WriteLine(list[0].ToString().PadLeft(len, '0').Replace('1', '#').Replace('0', '.').Reverse().Spaced());
        }
    }

    static List<BitSet> Generate(int length, params int[] runs) {
        var list = new List<BitSet>();
        BitSet initial = BitSet.Empty;
        int[] sums = new int[runs.Length];
        sums[0] = 0;
        for (int i = 1; i < runs.Length; i++) sums[i] = sums[i - 1] + runs[i - 1] + 1;
        for (int r = 0; r < runs.Length; r++) initial = initial.AddRange(sums[r], runs[r]);
        Generate(list, BitSet.Empty.Add(length), runs, sums, initial, 0, 0);
        return list;
    }

    static void Generate(List<BitSet> result, BitSet max, int[] runs, int[] sums, BitSet current, int index, int shift) {
        if (index == runs.Length) {
            result.Add(current);
            return;
        }
        while (current.Value < max.Value) {
            Generate(result, max, runs, sums, current, index + 1, shift);
            current = current.ShiftLeftAt(sums[index] + shift);
            shift++;
        }
    }

    static void Reduce(List<List<BitSet>> rows, List<List<BitSet>> columns) {
        for (int count = 1; count > 0; ) {
            foreach (var (rowIndex, row) in rows.WithIndex()) {
                var allOn  = row.Aggregate((a, b) => a & b);
                var allOff = row.Aggregate((a, b) => a | b);
                foreach (var (columnIndex, column) in columns.WithIndex()) {
                    count  = column.RemoveAll(c => allOn.Contains(columnIndex) && !c.Contains(rowIndex));
                    count += column.RemoveAll(c => !allOff.Contains(columnIndex) && c.Contains(rowIndex));
                }
            }
            foreach (var (columnIndex, column) in columns.WithIndex()) {
                var allOn  = column.Aggregate((a, b) => a & b);
                var allOff = column.Aggregate((a, b) => a | b);
                foreach (var (rowIndex, row) in rows.WithIndex()) {
                    count += row.RemoveAll(r => allOn.Contains(rowIndex) && !r.Contains(columnIndex));
                    count += row.RemoveAll(r => !allOff.Contains(rowIndex) && r.Contains(columnIndex));
                }
            }
        }
    }

    static IEnumerable<(int index, T element)> WithIndex<T>(this IEnumerable<T> source) {
        int i = 0;
        foreach (T element in source) {
            yield return (i++, element);
        }
    }

    static string Reverse(this string s) {
        char[] array = s.ToCharArray();
        Array.Reverse(array);
        return new string(array);
    }

    static string Spaced(this IEnumerable<char> s) => string.Join(" ", s);

    struct BitSet //Unused functionality elided.
    {
        public static BitSet Empty => default;
        private readonly int bits;
        public int Value => bits;

        private BitSet(int bits) => this.bits = bits;

        public BitSet Add(int item) => new BitSet(bits | (1 << item));
        public BitSet AddRange(int start, int count) => new BitSet(bits | (((1 << (start + count)) - 1) - ((1 << start) - 1)));
        public bool Contains(int item) => (bits & (1 << item)) != 0;
        public BitSet ShiftLeftAt(int index)  => new BitSet((bits >> index << (index + 1)) | (bits & ((1 << index) - 1)));
        public override string ToString() => Convert.ToString(bits, 2);

        public static BitSet operator &(BitSet a, BitSet b) => new BitSet(a.bits & b.bits);
        public static BitSet operator |(BitSet a, BitSet b) => new BitSet(a.bits | b.bits);
    }

}
