A ← {
  A 0‿n: n+1;
  A m‿0: A (m-1)‿1;
  A m‿n: A (m-1)‿(A m‿(n-1))
}
