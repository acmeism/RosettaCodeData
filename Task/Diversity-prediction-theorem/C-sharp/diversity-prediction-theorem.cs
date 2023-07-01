using System;
using System.Linq;
using System.Collections.Generic;

public class MainClass {
    static double Square(double x) => x * x;

    static double AverageSquareDiff(double a, IEnumerable<double> predictions)
        => predictions.Select(x => Square(x - a)).Average();

    static void DiversityTheorem(double truth, IEnumerable<double> predictions)
    {
        var average = predictions.Average();
        Console.WriteLine($@"average-error: {AverageSquareDiff(truth, predictions)}
crowd-error: {Square(truth - average)}
diversity: {AverageSquareDiff(average, predictions)}");
    }
	
    public static void Main() {
	DiversityTheorem(49, new []{48d,47,51});
    	DiversityTheorem(49, new []{48d,47,51,42});
    }
}
