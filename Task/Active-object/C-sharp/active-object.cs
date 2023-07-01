using System;
using System.Threading.Tasks;

using static System.Diagnostics.Stopwatch;
using static System.Math;
using static System.Threading.Thread;

class ActiveObject
{
    static double timeScale = 1.0 / Frequency;

    Func<double, double> func;
    Task updateTask;
    double integral;
    double value;
    long timestamp0, timestamp;

    public ActiveObject(Func<double, double> input)
    {
        timestamp0 = timestamp = GetTimestamp();
        func = input;
        value = func(0);
        updateTask = Integrate();
    }

    public void ChangeInput(Func<double, double> input)
    {
        lock (updateTask)
        {
            func = input;
        }
    }

    public double Value
    {
        get
        {
            lock (updateTask)
            {
                return integral;
            }
        }
    }

    async Task Integrate()
    {
        while (true)
        {
            await Task.Yield();
            var newTime = GetTimestamp();
            double newValue;

            lock (updateTask)
            {
                newValue = func((newTime - timestamp0) * timeScale);
                integral += (newValue + value) * (newTime - timestamp) * timeScale / 2;
            }

            timestamp = newTime;
            value = newValue;
        }
    }
}

class Program
{
    static Func<double, double> Sine(double frequency) =>
        t => Sin(2 * PI * frequency * t);

    static void Main(string[] args)
    {
        var ao = new ActiveObject(Sine(0.5));
        Sleep(TimeSpan.FromSeconds(2));
        ao.ChangeInput(t => 0);
        Sleep(TimeSpan.FromSeconds(0.5));
        Console.WriteLine(ao.Value);
    }
}
