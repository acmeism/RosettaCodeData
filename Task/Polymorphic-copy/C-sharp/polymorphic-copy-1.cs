using System;

class T
{
    public virtual string Name()
    {
        return "T";
    }

    public virtual T Clone()
    {
        return new T();
    }
}

class S : T
{
    public override string Name()
    {
        return "S";
    }

    public override T Clone()
    {
        return new S();
    }
}

class Program
{
    static void Main()
    {
        T original = new S();
        T clone = original.Clone();

        Console.WriteLine(original.Name());
        Console.WriteLine(clone.Name());
    }
}
