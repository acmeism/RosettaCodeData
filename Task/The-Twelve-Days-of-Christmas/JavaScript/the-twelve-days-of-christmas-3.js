JSON.stringify(function (h, k, l, f, m, n) {
  var c =
    "first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth"
    .split(" "),
    d = c.length,
    e =
    "A partridge in a pear tree.;Two turtle doves;Three french hens;Four calling birds;Five golden rings;Six geese a-laying;Seven swans a-swimming;Eight maids a-milking;Nine ladies dancing;Ten lords a-leaping;Eleven pipers piping;Twelve drummers drumming"
    .split(";"),
    g = function () {
      var b = e.slice(0);
      return b.reverse(), b;
    }(),
    p = [f, m, n + ":"].join(" "),
    q = g[d - 2] + " and",
    r = e[0];

  return c.reduce(function (b, f, a) {
    return b.concat([[[h, "the", c[a], l, "of", k].join(" "), p].concat((1 <
      a ? [e[a]] : []).concat(g.slice(d - a, d - 2)).concat([q, r].slice(a ?
      0 : 1)))]);
  }, []);
}("On", "Christmas", "day", "my true love", "gave to", "me"), null, 2);
