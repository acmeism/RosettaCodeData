using System;

public static class Angles
{
    public static void Main() => Print(-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 6399, 1_000_000);

    public static void Print(params double[] angles) {
        string[] names = { "Degrees", "Gradians", "Mils", "Radians" };
        Func<double, double> rnd = a => Math.Round(a, 4);
        Func<double, double>[] normal = { NormalizeDeg, NormalizeGrad, NormalizeMil, NormalizeRad };

        Func<double, double>[,] convert = {
            { a => a, DegToGrad, DegToMil, DegToRad },
            { GradToDeg, a => a, GradToMil, GradToRad },
            { MilToDeg, MilToGrad, a => a, MilToRad },
            { RadToDeg, RadToGrad, RadToMil, a => a }
        };

        Console.WriteLine($@"{"Angle",-12}{"Normalized",-12}{"Unit",-12}{
            "Degrees",-12}{"Gradians",-12}{"Mils",-12}{"Radians",-12}");

        foreach (double angle in angles) {
            for (int i = 0; i < 4; i++) {
                double nAngle = normal[i](angle);

                Console.WriteLine($@"{
                    rnd(angle),-12}{
                    rnd(nAngle),-12}{
                    names[i],-12}{
                    rnd(convert[i, 0](nAngle)),-12}{
                    rnd(convert[i, 1](nAngle)),-12}{
                    rnd(convert[i, 2](nAngle)),-12}{
                    rnd(convert[i, 3](nAngle)),-12}");
            }
        }
    }

    public static double NormalizeDeg(double angle) => Normalize(angle, 360);
    public static double NormalizeGrad(double angle) => Normalize(angle, 400);
    public static double NormalizeMil(double angle) => Normalize(angle, 6400);
    public static double NormalizeRad(double angle) => Normalize(angle, 2 * Math.PI);

    private static double Normalize(double angle, double N) {
        while (angle <= -N) angle += N;
        while (angle >= N) angle -= N;
        return angle;
    }

    public static double DegToGrad(double angle) => angle * 10 / 9;
    public static double DegToMil(double angle) => angle * 160 / 9;
    public static double DegToRad(double angle) => angle * Math.PI / 180;

    public static double GradToDeg(double angle) => angle * 9 / 10;
    public static double GradToMil(double angle) => angle * 16;
    public static double GradToRad(double angle) => angle * Math.PI / 200;

    public static double MilToDeg(double angle) => angle * 9 / 160;
    public static double MilToGrad(double angle) => angle / 16;
    public static double MilToRad(double angle) => angle * Math.PI / 3200;

    public static double RadToDeg(double angle) => angle * 180 / Math.PI;
    public static double RadToGrad(double angle) => angle * 200 / Math.PI;
    public static double RadToMil(double angle) => angle * 3200 / Math.PI;
}
