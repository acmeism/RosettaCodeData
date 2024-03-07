using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
	public static void Main(string[] args)
	{
		const double precision = 0.000001;
		Console.WriteLine($"Approximate area = {AreaScan(precision):F8}");
	}

	private static double AreaScan(double precision)
	{
		List<double> valuesY = new List<double>();
		foreach (var circle in circles)
		{
			valuesY.Add(circle.CentreY + circle.Radius);
			valuesY.Add(circle.CentreY - circle.Radius);
		}

		double min = valuesY.Min();
		double max = valuesY.Max();
		long minY = (long)Math.Floor(min / precision);
		long maxY = (long)Math.Ceiling(max / precision);
		double totalArea = 0.0;
		for (long i = minY; i <= maxY; i++)
		{
			double y = i * precision;
			double right = double.NegativeInfinity;
			List<PairX> pairsX = new List<PairX>();
			foreach (var circle in circles)
			{
				if (Math.Abs(y - circle.CentreY) < circle.Radius)
				{
					pairsX.Add(HorizontalSection(circle, y));
				}
			}

			pairsX.Sort((one, two) => one.X1.CompareTo(two.X1));
			foreach (var pairX in pairsX)
			{
				if (pairX.X2 > right)
				{
					totalArea += pairX.X2 - Math.Max(pairX.X1, right);
					right = pairX.X2;
				}
			}
		}

		return totalArea * precision;
	}

	private static PairX HorizontalSection(Circle circle, double y)
	{
		double value = Math.Pow(circle.Radius, 2) - Math.Pow(y - circle.CentreY, 2);
		double deltaX = Math.Sqrt(value);
		return new PairX(circle.CentreX - deltaX, circle.CentreX + deltaX);
	}

	private record PairX(double X1, double X2);
	private record Circle(double CentreX, double CentreY, double Radius);
	private static readonly List<Circle> circles = new List<Circle>
	{
		new Circle(1.6417233788, 1.6121789534, 0.0848270516),
		new Circle(-1.4944608174, 1.2077959613, 1.1039549836),
		new Circle(0.6110294452, -0.6907087527, 0.9089162485),
		new Circle(0.3844862411, 0.2923344616, 0.2375743054),
		new Circle(-0.2495892950, -0.3832854473, 1.0845181219),
		new Circle(1.7813504266, 1.6178237031, 0.8162655711),
		new Circle(-0.1985249206, -0.8343333301, 0.0538864941),
		new Circle(-1.7011985145, -0.1263820964, 0.4776976918),
		new Circle(-0.4319462812, 1.4104420482, 0.7886291537),
		new Circle(0.2178372997, -0.9499557344, 0.0357871187),
		new Circle(-0.6294854565, -1.3078893852, 0.7653357688),
		new Circle(1.7952608455, 0.6281269104, 0.2727652452),
		new Circle(1.4168575317, 1.0683357171, 1.1016025378),
		new Circle(1.4637371396, 0.9463877418, 1.1846214562),
		new Circle(-0.5263668798, 1.7315156631, 1.4428514068),
		new Circle(-1.2197352481, 0.9144146579, 1.0727263474),
		new Circle(-0.1389358881, 0.1092805780, 0.7350208828),
		new Circle(1.5293954595, 0.0030278255, 1.2472867347),
		new Circle(-0.5258728625, 1.3782633069, 1.3495508831),
		new Circle(-0.1403562064, 0.2437382535, 1.3804956588),
		new Circle(0.8055826339, -0.0482092025, 0.3327165165),
		new Circle(-0.6311979224, 0.7184578971, 0.2491045282),
		new Circle(1.4685857879, -0.8347049536, 1.3670667538),
		new Circle(-0.6855727502, 1.6465021616, 1.0593087096),
		new Circle(0.0152957411, 0.0638919221, 0.9771215985)
	};
}
