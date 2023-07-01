public delegate int Plus(int y);
public delegate Plus CurriedPlus(int x);
public static CurriedPlus plus =
      delegate(int x) {return delegate(int y) {return x + y;};};
static void Main()
{
    int sum = plus(3)(4); // sum = 7
    int sum2= plus(2)(plus(3)(4)) // sum2 = 9
}
