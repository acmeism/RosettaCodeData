using System; //Used for Exception and Console classes
class Exceptions
{
  class U0 : Exception { }
  class U1 : Exception { }
  static int i;
  static void foo()
  {
    for (i = 0; i < 2; i++)
      try
      {
        bar();
      }
      catch (U0) {
        Console.WriteLine("U0 Caught");
      }
  }
  static void bar()
  {
    baz();
  }
  static void baz(){
    if (i == 0)
      throw new U0();
    throw new U1();
  }

  public static void Main()
  {
    foo();
  }
}
