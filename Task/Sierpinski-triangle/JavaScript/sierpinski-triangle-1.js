// A Sierpinski triangle of order N,
// constructed as Pascal's triangle mod 2
// and mapped to 2^N lines of centred {1:asterisk, 0:space} strings

(function (n) {
  var nRows = Math.pow(2, n),
      lstSierpinski = sierpinski(nRows).map(asciiBinary),

      nBaseWidth = lstSierpinski[nRows - 1].length;

  return lstSierpinski.map(
    function (s) {
      return centreAligned(s, nBaseWidth);
    }
  ).join('\n');
})(4);

// A Sierpinski sieve of n rows
// (Pascal triangle mod 2)
// n --> [bool]
function sierpinski(n) {
  return pascalTriangle(n).map(
    function (line) {
      return line.map(function (x) {
        return x % 2;
      });
    }
  )
}

// A Pascal triangle of n rows
// n --> [[n]]
function pascalTriangle(n) {

  // Sums of each consecutive pair of numbers
  // [n] --> [n]
  function pairSums(lst) {
    return lst.reduce(function (acc, n, i, l) {
      var iPrev = i ? i - 1 : 0;
      return i ? acc.concat(l[iPrev] + l[i]) : acc
    }, []);
  }

  // Next line in a Pascal triangle series
  // [n] --> [n]
  function nextPascal(lst) {
    return lst.length ? [1].concat(
      pairSums(lst)
    ).concat(1) : [1];
  }

  // Each row is a function of the preceding row
  return n ? Array.apply(null, Array(n - 1)).reduce(
    function (a, _, i) {
      return a.concat(
        [nextPascal(a[i])]
      );
    }, [
      [1]
    ]
  ) : [];
}

// [bool] --> s
function asciiBinary(lst) {
  return lst.map(
    function (x) {
      return x ? '*' : ' ';
    }
  ).join(' ');
}

// Space-padded to left and right
// s --> n --> s
function centreAligned(s, n) {
  var lngWhite = n - s.length,
    lngMargin = lngWhite > 0 ? Math.ceil(lngWhite / 2) : 0,
    strMargin = lngMargin ? Array(lngMargin + 1).join(' ') : '';

  return strMargin ? strMargin + s + strMargin : s;
}
