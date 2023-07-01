    static void Main(string[] args) {
      Tuple<uint, string>[] ins = { new Tuple<uint,string>(3u, "Clear drains"),
                                    new Tuple<uint,string>(4u, "Feed cat"),
                                    new Tuple<uint,string>(5u, "Make tea"),
                                    new Tuple<uint,string>(1u, "Solve RC tasks"),
                                    new Tuple<uint,string>(2u, "Tax return") };

      var spq = ins.Aggregate(MinHeapPQ<string>.empty, (pq, t) => MinHeapPQ<string>.push(t.Item1, t.Item2, pq));
      foreach (var e in MinHeapPQ<string>.toSeq(spq)) Console.WriteLine(e); Console.WriteLine();

      foreach (var e in MinHeapPQ<string>.sort(ins)) Console.WriteLine(e); Console.WriteLine();

      var npq = MinHeapPQ<string>.fromSeq(ins);
      foreach (var e in MinHeapPQ<string>.toSeq(MinHeapPQ<string>.merge(npq, npq)))
        Console.WriteLine(e); Console.WriteLine();

      var npq = MinHeapPQ<string>.fromSeq(ins);
      foreach (var e in MinHeapPQ<string>.toSeq(MinHeapPQ<string>.merge(npq, npq)))
        Console.WriteLine(e);

      foreach (var e in MinHeapPQ<string>.toSeq(MinHeapPQ<string>.adjust((k, v) => new Tuple<uint,string>(6u - k, v), npq)))
        Console.WriteLine(e); Console.WriteLine();
    }
