const qsort = ([pivot, ...others]) =>
  pivot === void 0 ? [] : [
    ...qsort(others.filter(n => n < pivot)),
    pivot,
    ...qsort(others.filter(n => n >= pivot))
  ];

qsort( [ 11.8, 14.1, 21.3, 8.5, 16.7, 5.7 ] )
