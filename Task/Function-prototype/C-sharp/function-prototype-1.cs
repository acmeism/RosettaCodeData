using System;
abstract class Printer
{
    public abstract void Print();
}

class PrinterImpl : Printer
{
    public override void Print() {
        Console.WriteLine("Hello world!");
    }
}
