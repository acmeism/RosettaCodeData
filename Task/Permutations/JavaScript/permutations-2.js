(function () {

  // [a] -> [[a]]
  function permutations(xs) {
    return xs.length ? (
               chain( xs,                            function (x)  {
        return chain( permutations(deleted(x, xs)),  function (ys) {

        return ( [[x].concat(ys)] );

    })})) : [[]]
  }

  // monadic bind/chain for lists
  function chain(xs, f) {
    return [].concat.apply([], xs.map(f));
  }

  // drops first instance found
  function deleted(x, xs) {
    return xs.length ? (
      x === xs[0] ? xs.slice(1) : [xs[0]].concat(
        deleted(x, xs.slice(1))
      )
    ) : [];
  }

  return permutations(['Aardvarks', 'eat', 'ants'])

})();
