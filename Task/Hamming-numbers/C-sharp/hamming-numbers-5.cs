using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

namespace Hamming {

  class Hammings : IEnumerable<BigInteger> {
    private class LazyList<T> {
      public T v; public Lazy<LazyList<T>> cont;
      public LazyList(T v, Lazy<LazyList<T>> cont) {
        this.v = v; this.cont = cont;
      }
    }
    private uint[] primes;
    private Hammings() { } // must have an argument!!!
    public Hammings(uint[] prms) { this.primes = prms; }
    private LazyList<BigInteger> merge(LazyList<BigInteger> xs,
                                       LazyList<BigInteger> ys) {
      if (xs == null) return ys; else {
        var x = xs.v; var y = ys.v;
        if (BigInteger.Compare(x, y) < 0) {
          var cont = new Lazy<LazyList<BigInteger>>(() =>
                       merge(xs.cont.Value, ys));
          return new LazyList<BigInteger>(x, cont);
        }
        else {
          var cont = new Lazy<LazyList<BigInteger>>(() =>
                       merge(xs, ys.cont.Value));
          return new LazyList<BigInteger>(y, cont);
        }
      }
    }
    private LazyList<BigInteger> llmult(uint mltplr,
                                        LazyList<BigInteger> ll) {
      return new LazyList<BigInteger>(mltplr * ll.v,
                                      new Lazy<LazyList<BigInteger>>(() =>
                                        llmult(mltplr, ll.cont.Value)));
    }
    public IEnumerator<BigInteger> GetEnumerator() {
      Func<LazyList<BigInteger>,uint,LazyList<BigInteger>> u =
        (acc, p) => { LazyList<BigInteger> r = null;
                      var cont = new Lazy<LazyList<BigInteger>>(() => r);
                      r = new LazyList<BigInteger>(1, cont);
                      r = this.merge(acc, llmult(p, r));
                      return r; };
      yield return 1;
      for (var stt = primes.Aggregate(null, u); ; stt = stt.cont.Value)
        yield return stt.v;
    }
    IEnumerator IEnumerable.GetEnumerator() {
      return this.GetEnumerator();
    }
  }

  class Program {
    static void Main(string[] args) {
      Console.WriteLine("Calculates the Hamming sequence of numbers.\r\n");

      var primes = new uint[] { 5, 3, 2 };
      Console.WriteLine(String.Join(" ", (new Hammings(primes)).Take(20).ToArray()));
      Console.WriteLine((new Hammings(primes)).ElementAt(1691 - 1));

      var n = 1000000;

      var elpsd = -DateTime.Now.Ticks;

      var num = (new Hammings(primes)).ElementAt(n - 1);

      elpsd += DateTime.Now.Ticks;

      Console.WriteLine(num);
      Console.WriteLine("The {0}th hamming number took {1} milliseconds", n, elpsd / 10000);

      Console.Write("\r\nPress any key to exit:");
      Console.ReadKey(true);
      Console.WriteLine();
    }
  }
}
