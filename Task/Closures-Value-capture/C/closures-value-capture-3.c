void init(void)
{
  t = intern(lit("t"));
  x = intern(lit("x"));
}

val square(val env)
{
  val xbind = assoc(env, x); /* look up binding of variable x in env */
  val xval = cdr(xbind);     /* value is the cdr of the binding cell */
  return num(cnum(xval) * cnum(xval));
}

int main(void)
{
  int i;
  val funlist = nil, iter;

  init();

  for (i = 0; i < 10; i++) {
    val closure_env = cons(cons(x, num(i)), nil);
    funlist = cons(func_f0(closure_env, square), funlist);
  }

  for (iter = funlist; iter != nil; iter = cdr(iter)) {
    val fun = car(iter);
    val square = funcall(fun, nao);

    printf("%d\n", cnum(square));
  }
  return 0;
}
