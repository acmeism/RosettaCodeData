function first (func) {
  return func();
}

function second () {
  return "second";
}

var result = first(second);
result = first(function () { return "third"; });
