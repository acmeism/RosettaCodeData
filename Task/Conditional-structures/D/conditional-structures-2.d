 auto i = 5;
// is(T: U) tests if T is implicitly castable to U.
// typeof(var) is the type of the variable.
// also: is(T==U) checks if T is U.
static if (is(typeof(i) : int)) {
  ...
} else {
  ...
}
