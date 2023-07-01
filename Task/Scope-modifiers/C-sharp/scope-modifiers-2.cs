public interface IPrinter
{
    void Print();
}

public class IntPrinter : IPrinter
{
    void IPrinter.Print() { // explicit implementation
        Console.WriteLine(123);
    }

    public static void Main() {
        //====Error====
        IntPrinter p = new IntPrinter();
        p.Print();

        //====Valid====
        IPrinter p = new IntPrinter();
        p.Print();
    }
}
