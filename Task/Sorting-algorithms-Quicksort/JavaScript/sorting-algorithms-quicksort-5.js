function qsort( xs ){
  return xs.length === 0 ? [] : [].concat(
    qsort( xs.slice(1).filter(function(x){ return x< xs[0] })),
    xs[0],
    qsort( xs.slice(1).filter(function(x){ return x>= xs[0] }))
  )
}
qsort( [ 11.8, 14.1, 21.3, 8.5, 16.7, 5.7 ] )
