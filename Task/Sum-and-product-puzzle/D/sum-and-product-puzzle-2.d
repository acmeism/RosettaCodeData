    const s1 = iota(1, 101).map!(x => iota(1, 101).map!(y => tuple(x, y))).joiner
