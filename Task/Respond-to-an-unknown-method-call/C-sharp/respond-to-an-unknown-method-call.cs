using System;
using System.Dynamic;

class Example : DynamicObject
{
    public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
    {
        result = null;

        Console.WriteLine("This is {0}.", binder.Name);
        return true;
    }
}

class Program
{
    static void Main(string[] args)
    {
        dynamic ex = new Example();

        ex.Foo();
        ex.Bar();
    }
}
