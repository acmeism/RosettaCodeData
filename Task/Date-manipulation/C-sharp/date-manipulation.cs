class Program
{
    static void Main(string[] args)
    {
        CultureInfo ci=CultureInfo.CreateSpecificCulture("en-US");
        string dateString = "March 7 2009 7:30pm EST";
        string format = "MMMM d yyyy h:mmtt z";
        DateTime myDateTime = DateTime.ParseExact(dateString.Replace("EST","+6"),format,ci) ;
        DateTime newDateTime = myDateTime.AddHours(12).AddDays(1) ;
        Console.WriteLine(newDateTime.ToString(format).Replace("-5","EST")); //probably not the best way to do this

        Console.ReadLine();
    }
}
