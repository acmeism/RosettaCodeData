function fib(n)
{
 var
  a = 0,
  b = 1,
  t;
 while (n-- > 0)
 {
  t = a;
  a = b;
  b += t;
 }
 return a;
}

var i;
for (i = 0; i < 10; ++i)
 alert(fib(i));
