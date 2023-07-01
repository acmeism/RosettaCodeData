Module Program
    Sub Main()
        Dim millisecondsSleepTime = Integer.Parse(Console.ReadLine(), Globalization.CultureInfo.CurrentCulture)
        Console.WriteLine("Sleeping...")
        Threading.Thread.Sleep(millisecondsSleepTime)
        Console.WriteLine("Awake!")
    End Sub
End Module
