using System;
using System.Threading;

public class Program
{
    public static void Main(string[] args)
    {
        Metronome metronome1 = new Metronome(120, 4);
        metronome1.Start();
    }
}

public class Metronome
{
    private double bpm;
    private int measure;
    private int counter;

    public Metronome(double bpm, int measure)
    {
        this.bpm = bpm;
        this.measure = measure;
    }

    public void Start()
    {
        Thread thread = new Thread(() =>
        {
            while (true)
            {
                try
                {
                    Thread.Sleep((int)(1000 * (60.0 / bpm)));
                }
                catch (ThreadInterruptedException e)
                {
                    Console.WriteLine(e.StackTrace);
                }
                counter++;
                if (counter % measure == 0)
                {
                    Console.WriteLine("TICK");
                }
                else
                {
                    Console.WriteLine("TOCK");
                }
            }
        });

        thread.Start();
    }
}
