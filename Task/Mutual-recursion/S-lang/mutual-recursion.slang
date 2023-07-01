% Forward definitions: [also deletes any existing definition]
define f();
define m();

define f(n) {
  if (n == 0) return 1;
  else if (n < 0) error("oops");
  return n - m(f(n - 1));
}

define m(n) {
  if (n == 0) return 0;
  else if (n < 0) error("oops");
  return n - f(m(n - 1));
}

foreach $1 ([0:19])
  () = printf("%d  ", f($1));
() = printf("\n");
foreach $1 ([0:19])
  () = printf("%d  ", m($1));
() = printf("\n");
