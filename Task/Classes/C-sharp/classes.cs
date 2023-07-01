public class MyClass
{
    public MyClass()
    {
    }
    public void SomeMethod()
    {
    }
    private int _variable;
    public int Variable
    {
        get { return _variable; }
        set { _variable = value; }
    }
    public static void Main()
    {
        // instantiate it
        MyClass instance = new MyClass();
        // invoke the method
        instance.SomeMethod();
        // set the variable
        instance.Variable = 99;
        // get the variable
        System.Console.WriteLine( "Variable=" + instance.Variable.ToString() );
    }
}
