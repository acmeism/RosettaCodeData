using System;

namespace RosettaCode
{
  internal sealed class Program
  {
    private static void Main()
    {
      Func<double> getDouble = () => Convert.ToDouble(Console.ReadLine());
      double h = 0, lat, lng, lme, slat, hra, hla;

      Console.Write("Enter latitude       => ");
      lat = getDouble();
      Console.Write("Enter longitude      => ");
      lng = getDouble();
      Console.Write("Enter legal meridian => ");
      lme = getDouble();

      slat = Math.Sin(lat*2*Math.PI/360);
      Console.WriteLine("\n    sine of latitude:   {0:0.000}", slat);
      Console.WriteLine("    diff longitude:     {0:0.000}\n", lng-lme);
      Console.WriteLine("Hour, sun hour angle, dial hour line angle from 6am to 6pm");
      for (h = -6; h<6; h++)
      {
        hra = 15*h;
        hra -= lng-lme;
        hla = Math.Atan(slat*Math.Tan(hra*2*Math.PI/360))*360/(2*Math.PI);
        Console.WriteLine("HR= {0,7:0.000}; HRA {1,7:0.000}; HLA= {2,7:0.000}", h, hra, hla);
      }
    }
  }
}
