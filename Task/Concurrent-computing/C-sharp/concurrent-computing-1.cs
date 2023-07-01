static Random tRand = new Random();

static void Main(string[] args)
{
	Thread t = new Thread(new ParameterizedThreadStart(WriteText));
	t.Start("Enjoy");

	t = new Thread(new ParameterizedThreadStart(WriteText));
	t.Start("Rosetta");

	t = new Thread(new ParameterizedThreadStart(WriteText));
	t.Start("Code");

	Console.ReadLine();
}

private static void WriteText(object p)
{
	Thread.Sleep(tRand.Next(1000, 4000));
	Console.WriteLine(p);
}
