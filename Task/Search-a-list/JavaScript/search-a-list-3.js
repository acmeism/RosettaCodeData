(function () {

  function findIndex(fnPredicate, list) {
    for (var i = 0, lng = list.length; i < lng; i++) {
      if (fnPredicate(list[i])) {
        return i;
      }
    }
    return Error("not found");
  };

  // DEFINING A PARTICULAR TYPE OF SEARCH MATCH

  function matchCaseInsensitive(s, t) {
    return s.toLowerCase() === t.toLowerCase();
  }

  var lstHaystack = [
    'Zig', 'Zag', 'Wally', 'Ronald', 'Bush',
    'Krusty', 'Charlie', 'Bush', 'Bozo'
  ],
    lstReversed = lstHaystack.slice(0).reverse(),
    iLast = lstHaystack.length - 1,
    lstNeedles = ['bush', 'washington'];

  return {
    'first': lstNeedles.map(function (s) {
      return [s, findIndex(function (t) {
          return matchCaseInsensitive(s, t);
        },
        lstHaystack)];
    }),

    'last': lstNeedles.map(function (s) {
      var varIndex = findIndex(function (t) {
          return matchCaseInsensitive(s, t);
        },
        lstReversed);

      return [
        s,
        typeof varIndex === 'number' ?
          iLast - varIndex : varIndex
      ];
    })
  }
})();
