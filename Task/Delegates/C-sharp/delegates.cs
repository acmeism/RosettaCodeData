using System;

interface IOperable
{
    string Operate();
}

class Inoperable
{
}

class Operable : IOperable
{
    public string Operate()
    {
        return "Delegate implementation.";
    }
}

class Delegator : IOperable
{
    object Delegate;

    public string Operate()
    {
        var operable = Delegate as IOperable;
        return operable != null ? operable.Operate() : "Default implementation.";
    }

    static void Main()
    {
        var delegator = new Delegator();
        foreach (var @delegate in new object[] { null, new Inoperable(), new Operable() })
        {
            delegator.Delegate = @delegate;
            Console.WriteLine(delegator.Operate());
        }
    }
}
