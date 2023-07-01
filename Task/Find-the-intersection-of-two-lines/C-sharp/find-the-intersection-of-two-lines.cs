using System;
using System.Drawing;
public class Program
{
    static PointF FindIntersection(PointF s1, PointF e1, PointF s2, PointF e2) {
        float a1 = e1.Y - s1.Y;
        float b1 = s1.X - e1.X;
        float c1 = a1 * s1.X + b1 * s1.Y;

        float a2 = e2.Y - s2.Y;
        float b2 = s2.X - e2.X;
        float c2 = a2 * s2.X + b2 * s2.Y;

        float delta = a1 * b2 - a2 * b1;
        //If lines are parallel, the result will be (NaN, NaN).
        return delta == 0 ? new PointF(float.NaN, float.NaN)
            : new PointF((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta);
    }

    static void Main() {
        Func<float, float, PointF> p = (x, y) => new PointF(x, y);
        Console.WriteLine(FindIntersection(p(4f, 0f), p(6f, 10f), p(0f, 3f), p(10f, 7f)));
        Console.WriteLine(FindIntersection(p(0f, 0f), p(1f, 1f), p(1f, 2f), p(4f, 5f)));
    }
}
