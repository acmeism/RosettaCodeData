using System; using static System.Console;
using System.Collections.Generic; using System.Linq;

class Program {

  static void Main(string[] args) {

    List<uint> cubes = new List<uint>(), sums = new List<uint>();

    void dump(string title, Dictionary <int, uint> items) {
      Write(title); foreach (var item in items) {
        Write("\n{0,4} {1,10}", item.Key, item.Value);
        foreach (uint x in cubes) { uint y = item.Value - x;
          if (y < x) break; if (cubes.Contains(y))
            Write(" = {0,4}³ + {1,3}³", cubes.IndexOf(y), cubes.IndexOf(x));
      } } }

    DateTime st = DateTime.Now;
    // create sorted list of cube sums
    for (uint i = 0, cube; i < 1190; i++) { cube = i * i * i;
      cubes.Add(cube); foreach (uint j in cubes)
        sums.Add(cube + j); } sums.Sort();
    // now seek consecutive sums that match
    uint nm1 = sums[0], n = sums[1]; int idx = 0;
    Dictionary <int, uint> task = new Dictionary <int, uint>(),
                           trips = new Dictionary <int, uint>();
    foreach (var np1 in sums.Skip(2)) {
      if (nm1 == np1) trips.Add(idx, n); if (nm1 != n && n == np1)
        if (++idx <= 25 || idx >= 2000 == idx <= 2006)
          task.Add(idx, n); nm1 = n; n = np1; }
    // show results
    dump("First 25 Taxicab Numbers, the 2000th, plus the next half-dozen:", task);
    dump(string.Format("\n\nFound {0} triple Taxicabs under {1}:", trips.Count, 2007), trips);
    Write("\n\nElasped: {0}ms", (DateTime.Now - st).TotalMilliseconds); }
}
