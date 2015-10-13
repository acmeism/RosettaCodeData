namespace PriorityQ {
  using KeyT = UInt32;
  using System;
  using System.Collections.Generic;
  using System.Linq;
  class Tuple<K, V> { // for DotNet 3.5 without Tuple's
    public K Item1; public V Item2;
    public Tuple(K k, V v) { Item1 = k; Item2 = v; }
    public override string ToString() {
      return "(" + Item1.ToString() + ", " + Item2.ToString() + ")";
    }
  }
  class MinHeapPQ<V> {
    private struct HeapEntry {
      public KeyT k; public V v;
      public HeapEntry(KeyT k, V v) { this.k = k; this.v = v; }
    }
    private List<HeapEntry> pq;
    private MinHeapPQ() { this.pq = new List<HeapEntry>(); }
    private bool mt { get { return pq.Count == 0; } }
    private int sz {
      get {
        var cnt = pq.Count;
        return (cnt == 0) ? 0 : cnt - 1;
      }
    }
    private Tuple<KeyT, V> pkmn {
      get {
        if (pq.Count == 0) return null;
        else {
          var mn = pq[0];
          return new Tuple<KeyT, V>(mn.k, mn.v);
        }
      }
    }
    private void psh(KeyT k, V v) { // add extra very high item if none
      if (pq.Count == 0) pq.Add(new HeapEntry(UInt32.MaxValue, v));
      var i = pq.Count; pq.Add(pq[i - 1]); // copy bottom item...
      for (var ni = i >> 1; ni > 0; i >>= 1, ni >>= 1) {
        var t = pq[ni - 1];
        if (t.k > k) pq[i - 1] = t; else break;
      }
      pq[i - 1] = new HeapEntry(k, v);
    }
    private void siftdown(KeyT k, V v, int ndx) {
      var cnt = pq.Count - 1; var i = ndx;
      for (var ni = i + i + 1; ni < cnt; ni = ni + ni + 1) {
        var oi = i; var lk = pq[ni].k; var rk = pq[ni + 1].k;
        var nk = k;
        if (k > lk) { i = ni; nk = lk; }
        if (nk > rk) { ni += 1; i = ni; }
        if (i != oi) pq[oi] = pq[i]; else break;
      }
      pq[i] = new HeapEntry(k, v);
    }
    private void rplcmin(KeyT k, V v) {
      if (pq.Count > 1) siftdown(k, v, 0);
    }
    private void dltmin() {
      var lsti = pq.Count - 2;
      if (lsti <= 0) pq.Clear();
      else {
        var lkv = pq[lsti];
        pq.RemoveAt(lsti); siftdown(lkv.k, lkv.v, 0);
      }
    }
    private void reheap(int i) {
      var lfti = i + i + 1;
      if (lfti < sz) {
        var rghti = lfti + 1; reheap(lfti); reheap(rghti);
        var ckv = pq[i]; siftdown(ckv.k, ckv.v, i);
      }
    }
    private void bld(IEnumerable<Tuple<KeyT, V>> sq) {
      var sqm = from e in sq
                select new HeapEntry(e.Item1, e.Item2);
      pq = sqm.ToList<HeapEntry>();
      var sz = pq.Count;
      if (sz > 0) {
        var lkv = pq[sz - 1];
        pq.Add(new HeapEntry(KeyT.MaxValue, lkv.v));
        reheap(0);
      }
    }
    private IEnumerable<Tuple<KeyT, V>> sq() {
      return from e in pq
             where e.k != KeyT.MaxValue
             select new Tuple<KeyT, V>(e.k, e.v); }
    private void adj(Func<KeyT, V, Tuple<KeyT, V>> f) {
      var cnt = pq.Count - 1;
      for (var i = 0; i < cnt; ++i) {
        var e = pq[i];
        var r = f(e.k, e.v);
        pq[i] = new HeapEntry(r.Item1, r.Item2);
      }
      reheap(0);
    }
    public static MinHeapPQ<V> empty { get { return new MinHeapPQ<V>(); } }
    public static bool isEmpty(MinHeapPQ<V> pq) { return pq.mt; }
    public static int size(MinHeapPQ<V> pq) { return pq.sz; }
    public static Tuple<KeyT, V> peekMin(MinHeapPQ<V> pq) { return pq.pkmn; }
    public static MinHeapPQ<V> push(KeyT k, V v, MinHeapPQ<V> pq) {
      pq.psh(k, v); return pq; }
    public static MinHeapPQ<V> replaceMin(KeyT k, V v, MinHeapPQ<V> pq) {
      pq.rplcmin(k, v); return pq; }
    public static MinHeapPQ<V> deleteMin(MinHeapPQ<V> pq) { pq.dltmin(); return pq; }
    public static MinHeapPQ<V> merge(MinHeapPQ<V> pq1, MinHeapPQ<V> pq2) {
      return fromSeq(pq1.sq().Concat(pq2.sq())); }
    public static MinHeapPQ<V> adjust(Func<KeyT, V, Tuple<KeyT, V>> f, MinHeapPQ<V> pq) {
      pq.adj(f); return pq; }
    public static MinHeapPQ<V> fromSeq(IEnumerable<Tuple<KeyT, V>> sq) {
      var pq = new MinHeapPQ<V>(); pq.bld(sq); return pq; }
    public static Tuple<Tuple<KeyT, V>, MinHeapPQ<V>> popMin(MinHeapPQ<V> pq) {
      var rslt = pq.pkmn; if (rslt == null) return null;
      pq.dltmin(); return new Tuple<Tuple<KeyT, V>, MinHeapPQ<V>>(rslt, pq); }
    public static IEnumerable<Tuple<KeyT, V>> toSeq(MinHeapPQ<V> pq) {
      for (; !pq.mt; pq.dltmin()) yield return pq.pkmn; }
    public static IEnumerable<Tuple<KeyT, V>> sort(IEnumerable<Tuple<KeyT, V>> sq) {
      return toSeq(fromSeq(sq)); }
  }
}
