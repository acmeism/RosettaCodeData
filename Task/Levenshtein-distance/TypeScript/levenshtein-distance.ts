  function levenshtein(a: string, b: string): number {
    const m: number = a.length,
      n: number = b.length;
    let t: number[] = [...Array(n + 1).keys()],
      u: number[] = [];
    for (let i: number = 0; i < m; i++) {
      u = [i + 1];
      for (let j: number = 0; j < n; j++) {
        u[j + 1] = a[i] === b[j] ? t[j] : Math.min(t[j], t[j + 1], u[j]) + 1;
      }
      t = u;
    }
    return u[n] ?? n;
  }
