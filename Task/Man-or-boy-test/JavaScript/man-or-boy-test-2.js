var x = n => () => n;

var a = (k, x1, x2, x3, x4, x5) => {
  var b = () => return a(--k, b, x1, x2, x3, x4); //decrement k before use
  return (k > 0) ? b() : x4() + x5();
};
