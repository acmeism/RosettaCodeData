namespace PriorityQ {
  using KeyT = System.UInt32;
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
      if (pq.Count > 1) siftdown(k, v, 0); }
    public static MinHeapPQ<V> empty { get { return new MinHeapPQ<V>(); } }
    public static Tuple<KeyT, V> peekMin(MinHeapPQ<V> pq) { return pq.pkmn; }
    public static MinHeapPQ<V> push(KeyT k, V v, MinHeapPQ<V> pq) {
      pq.psh(k, v); return pq; }
    public static MinHeapPQ<V> replaceMin(KeyT k, V v, MinHeapPQ<V> pq) {
      pq.rplcmin(k, v); return pq; }
}
