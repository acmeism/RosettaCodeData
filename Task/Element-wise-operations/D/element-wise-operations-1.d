import std.stdio, std.typetuple, std.traits;

T[][] elementwise(string op, T, U)(in T[][] A, in U B) {
  auto R = new typeof(return)(A.length, A[0].length);
  foreach (r, row; A)
    R[r][] = mixin("row[] " ~ op ~ (isNumeric!U ? "B" : "B[r][]"));
  return R;
}

void main() {
  const M = [[3, 5, 7], [1, 2, 3], [2, 4, 6]];
  foreach (op; TypeTuple!("+", "-", "*", "/", "^^"))
    writefln("%s:\n[%([%(%d, %)],\n %)]]\n\n[%([%(%d, %)],\n %)]]\n",
             op, elementwise!op(M, 2), elementwise!op(M, M));
}
