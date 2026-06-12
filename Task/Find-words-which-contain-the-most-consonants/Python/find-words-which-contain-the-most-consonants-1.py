print('\n'.join((f'{x[0]}: {" ".join(sorted(x[1]))}' if len(x[1]) < 30 else f'{x[0]}: {len(x[1])} words' for x in
      (x for x in ((n, [x[1] for x in l if x[0] == n]) for n in range(maxlen, -1, -1)) if x[1]))) if (maxlen := max(l := [(len(c), w)
      for w in [l for l in [l.rstrip() for l in open('unixdict.txt')] if len(l) > 10 and all(c >= 'a' and c <= 'z' for c in l)]
      if sorted(c := w.replace('a', '').replace('e', '').replace('i', '').replace('o', '').replace('u', '')) == sorted(set(c))])[0]) else None)
