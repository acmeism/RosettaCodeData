using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using PrimeT = System.UInt32;
  class PrimesTreeFold : IEnumerable<PrimeT> {
    private struct CIS<T> {
      public T v; public Func<CIS<T>> cont;
      public CIS(T v, Func<CIS<T>> cont) {
        this.v = v; this.cont = cont;
      }
    }
    private CIS<PrimeT> pmlts(PrimeT p) {
      var adv = p + p;
      Func<PrimeT, CIS<PrimeT>> fn = null;
      fn = (c) => new CIS<PrimeT>(c, () => fn(c + adv));
      return fn(p * p);
    }
    private CIS<CIS<PrimeT>> allmlts(CIS<PrimeT> ps) {
      return new CIS<CIS<PrimeT>>(pmlts(ps.v), () => allmlts(ps.cont()));
    }
    private CIS<PrimeT> merge(CIS<PrimeT> xs, CIS<PrimeT> ys) {
      var x = xs.v; var y = ys.v;
      if (x < y) return new CIS<PrimeT>(x, () => merge(xs.cont(), ys));
      else if (y < x) return new CIS<PrimeT>(y, () => merge(xs, ys.cont()));
      else return new CIS<PrimeT>(x, () => merge(xs.cont(), ys.cont()));
    }
    private CIS<CIS<PrimeT>> pairs(CIS<CIS<PrimeT>> css) {
      var nxtcss = css.cont();
      return new CIS<CIS<PrimeT>>(merge(css.v, nxtcss.v), () => pairs(nxtcss.cont())); }
    private CIS<PrimeT> cmpsts(CIS<CIS<PrimeT>> css) {
      return new CIS<PrimeT>(css.v.v, () => merge(css.v.cont(), cmpsts(pairs(css.cont()))));
    }
    private CIS<PrimeT> minusat(PrimeT n, CIS<PrimeT> cs) {
      var nn = n; var ncs = cs;
      for (; ; nn += 2) {
        if (nn >= ncs.v) ncs = ncs.cont();
        else return new CIS<PrimeT>(nn, () => minusat(nn + 2, ncs));
      }
    }
    private CIS<PrimeT> oddprms() {
      return new CIS<PrimeT>(3, () => minusat(5, cmpsts(allmlts(oddprms()))));
    }
    public IEnumerator<PrimeT> GetEnumerator() {
      yield return 2;
      for (var ps = oddprms(); ; ps = ps.cont()) yield return ps.v;
    }
    IEnumerator IEnumerable.GetEnumerator() { return (IEnumerator)GetEnumerator(); }
  }
