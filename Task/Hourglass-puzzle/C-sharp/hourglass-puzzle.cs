using System;
using System.Collections.Generic;

enum FlipAction { FLIP4, FLIP7, FLIPBOTH }

struct HourglassesState
{
    public int timeStamp;
    public int glass4TimeLeft;
    public int glass7TimeLeft;

    public void Flip(FlipAction flipAction)
    {
        if (flipAction == FlipAction.FLIP4) {
            glass4TimeLeft = 4 - glass4TimeLeft;
        }
        else if (flipAction == FlipAction.FLIP7) {
            glass7TimeLeft = 7 - glass7TimeLeft;
        }
        else if (flipAction == FlipAction.FLIPBOTH) {
            glass4TimeLeft = 4 - glass4TimeLeft;
            glass7TimeLeft = 7 - glass7TimeLeft;
        }
    }

    public void RunToNextTimestamp()
    {
        if (glass4TimeLeft == 0) {
            timeStamp += glass7TimeLeft;
            glass4TimeLeft = 0;
            glass7TimeLeft = 0;
        }
        else if (glass7TimeLeft == 0) {
            timeStamp += glass4TimeLeft;
            glass4TimeLeft = 0;
            glass7TimeLeft = 0;
        }
        else {
            int deltaT = Math.Min(glass4TimeLeft, glass7TimeLeft);
            timeStamp += deltaT;
            glass4TimeLeft -= deltaT;
            glass7TimeLeft -= deltaT;
        }
    }
}

class Program
{
    static List<HourglassesState> hourglassesStates = new();
    static List<FlipAction> flipSequence = new();
    static int target = 9;

    static void Process(FlipAction flipAction)
    {
        var newState = hourglassesStates.Last();
        newState.Flip(flipAction);
        newState.RunToNextTimestamp();

        hourglassesStates.Add(newState);
        flipSequence.Add(flipAction);
    }

    static void Undo()
    {
        hourglassesStates.RemoveAt(hourglassesStates.Count - 1);
        flipSequence.RemoveAt(flipSequence.Count - 1);
    }

    static void Backtracking()
    {
        if (hourglassesStates.Last().timeStamp > target)
            return;

        if (hourglassesStates.Last().timeStamp == target) {
            ShowSolution(flipSequence);
            Environment.Exit(0);
        }

        foreach (var flipAction in Enum.GetValues<FlipAction>()) {
            Process(flipAction);
            Backtracking();
            Undo();
        }
    }

    static void ShowSolution(List<FlipAction> flipSequence)
    {
        Console.WriteLine("Time    Time left     Time left");
        Console.WriteLine("        in Glass 4    in Glass 7");

        var hs = new HourglassesState();
        Console.WriteLine("{0,3} {1,9} {2,12}", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);

        foreach (var flipAction in flipSequence) {
            if (flipAction == FlipAction.FLIP4)
                Console.WriteLine("{0,15} {1,12}", "flip", "");
            if (flipAction == FlipAction.FLIP7)
                Console.WriteLine("{0,15} {1,12}", "", "flip");
            if (flipAction == FlipAction.FLIPBOTH)
                Console.WriteLine("{0,15} {1,12}", "flip", "flip");

            hs.Flip(flipAction);
            Console.WriteLine("{0,3} {1,9} {2,12}", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);

            hs.RunToNextTimestamp();
            Console.WriteLine("{0,3} {1,9} {2,12}", hs.timeStamp, hs.glass4TimeLeft, hs.glass7TimeLeft);
        }
    }

    public static void Main()
    {
        hourglassesStates.Add(new HourglassesState());

        Backtracking();
    }
}
