  const bigInt = require('big-integer');
  const cache = new Map();
  function rev(bi) {
      const s = bi.toString().split('').reverse().join('');
      return bigInt(s);
  }
  function lychrel(n) {
      if (cache.has(n.toString())) { // bigInt 是对象，需要用字符串作为 Map 的键
          return cache.get(n.toString());
      }
      let r = rev(n);
      let res = { flag: true, bi: n };
      const seen = [];
      for (let i = 0; i < 500; i++) {
          n = n.add(r);
          r = rev(n);
          if (n.equals(r)) {
              res = { flag: false, bi: bigInt(0) };
              break;
          }
          if (cache.has(n.toString())) {
              res = cache.get(n.toString());
              break;
          }
          seen.push(n);
      }
      for (const bi of seen) {
          cache.set(bi.toString(), res);
      }
      return res;
  }
  const seeds = [];
  const related = [];
  const palin = [];
  for (let i = 1; i <= 10000; i++) {
      const n = bigInt(i);
      const t = lychrel(n);
      if (!t.flag) {
          continue;
      }
      if (n.equals(t.bi)) {
          seeds.push(t.bi);
      } else {
          related.push(t.bi);
      }
      if (n.equals(t.bi)) {
          palin.push(t.bi);
      }
  }
  console.log(`${seeds.length} Lychrel seeds: [${seeds.map(s => s.toString()).join(', ')}]`);
  console.log(`${related.length} Lychrel related`);
  console.log(`${palin.length} Lychrel palindromes: [${palin.map(p => p.toString()).join(', ')}]`);
