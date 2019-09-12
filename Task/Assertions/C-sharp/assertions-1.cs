using System.Diagnostics; // Debug and Trace are in this namespace.

static class Program
{
    static void Main()
    {
        int a = 0;

        Console.WriteLine("Before");

        // Always hit.
        Trace.Assert(a == 42, "Trace assertion failed");

        Console.WriteLine("After Trace.Assert");

        // Only hit in debug builds.
        Debug.Assert(a == 42, "Debug assertion failed");

        Console.WriteLine("After Debug.Assert");
    }
}
