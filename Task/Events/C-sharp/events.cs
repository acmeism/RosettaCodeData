using System;
using System.Timers;

class Program
{
    static void Main()
    {
        var timer = new Timer(1000);
        timer.Elapsed += new ElapsedEventHandler(OnElapsed);
        Console.WriteLine(DateTime.Now);
        timer.Start();
        Console.ReadLine();
    }

    static void OnElapsed(object sender, ElapsedEventArgs eventArgs)
    {
        Console.WriteLine(eventArgs.SignalTime);
        ((Timer)sender).Stop();
    }
}
