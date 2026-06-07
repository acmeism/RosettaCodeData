using Microsoft.VisualBasic.FileIO;
using System.Globalization;

struct GeoPos
{
    public double Lat;
    public double Lon;

    public GeoPos(double lat, double lon) { Lat = lat; Lon = lon; }

    private static double SinDeg(double x) => Math.Sin(x * Math.PI / 180.0);
    private static double CosDeg(double x) => Math.Cos(x * Math.PI / 180.0);

    public double DistanceTo(GeoPos other)
    {
        double a = Math.Pow(SinDeg((other.Lat - Lat) / 2), 2)
            + CosDeg(Lat) * CosDeg(other.Lat) * Math.Pow(SinDeg((other.Lon - Lon) / 2), 2);
        double R = 6372.8 / 1.852;
        return 2 * R * Math.Asin(Math.Sqrt(a));
    }

    public double BearingTo(GeoPos other)
    {
        double theta = Math.Atan2(SinDeg(other.Lon - Lon) * CosDeg(other.Lat),
            CosDeg(Lat) * SinDeg(other.Lat) - SinDeg(Lat) * CosDeg(other.Lat) * CosDeg(other.Lon - Lon));
        return (theta / (Math.PI / 180.0) + 360.0) % 360.0;
    }
};

struct Airport
{
    public string Name;
    public string Country;
    public string ICAO;
    public double Distance;
    public double Bearing;

    public Airport(string[] fields, GeoPos refPos)
    {
        Name = fields[1];
        Country = fields[3];
        ICAO = fields[5];

        GeoPos pos = new GeoPos(double.Parse(fields[6]), double.Parse(fields[7]));
        Distance = refPos.DistanceTo(pos);
        Bearing = refPos.BearingTo(pos);
    }
}

class Program
{
    static void Main()
    {
        Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;

        var parser = new TextFieldParser("airports.dat");
        parser.SetDelimiters(",");
        parser.HasFieldsEnclosedInQuotes = true;

        GeoPos refPos = new GeoPos(51.514669, 2.198581);
        var airports = new List<Airport>();

        while (!parser.EndOfData)
            airports.Add(new Airport(parser.ReadFields()!, refPos));

        Console.WriteLine("Airport                              Country         ICAO  Distance  Bearing");
        Console.WriteLine("----------------------------------------------------------------------------");
        foreach (var a in airports.OrderBy(a => a.Distance).Take(20)) {
            Console.WriteLine("{0,-36} {1,-15} {2,-8} {3,5:f1} {4,8:f0}",
                              a.Name, a.Country, a.ICAO, a.Distance, a.Bearing);
        }
    }
}
