Array.prototype.bind = function (func) {
  return this.map(func).reduce(function (acc, a) { return acc.concat(a); });
}

Array.unit = function (elem) {
  return [elem];
}

Array.lift = function (func) {
  return function (elem) { return Array.unit(func(elem)); };
}

inc = function (n) { return n + 1; }
doub = function (n) { return 2 * n; }
listy_inc = Array.lift(inc);
listy_doub = Array.lift(doub);

[3,4,5].bind(listy_inc).bind(listy_doub); // [8, 10, 12]
