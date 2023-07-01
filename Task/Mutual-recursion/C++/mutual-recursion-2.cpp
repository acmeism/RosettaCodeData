class Hofstadter
{
public:
  static int F(int n);
  static int M(int n);
};

int Hofstadter::F(int n)
{
  if ( n == 0 ) return 1;
  return n - M(F(n-1));
}

int Hofstadter::M(int n)
{
  if ( n == 0 ) return 0;
  return n - F(M(n-1));
}
