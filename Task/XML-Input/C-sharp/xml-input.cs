class Program
{
    static void Main(string[] args)
    {
        XDocument xmlDoc = XDocument.Load("XMLFile1.xml");
        var query = from p in xmlDoc.Descendants("Student")
                    select p.Attribute("Name");

        foreach (var item in query)
        {
            Console.WriteLine(item.Value);
        }
        Console.ReadLine();
    }
}
