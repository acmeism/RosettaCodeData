var (c, r) = GetCircle(new(22.83, 2.07), new(14.39, 30.24), new(33.65, 17.31));
Console.WriteLine($"center = {c.X}, {c.Y}, radius = {r}");

static (Vec2d Center, double Radius) GetCircle(Vec2d a, Vec2d b, Vec2d c)
{
    double
        aa = a * a,
        sab = aa - b * b,
        sac = aa - c * c;

    Vec2d
        ab = a - b,
        ac = a - c,
        p = new((sac * ab.Y - sab * ac.Y) / (ac.X * ab.Y - ab.X * ac.Y) / 2,
                (sac * ab.X - sab * ac.X) / (ac.Y * ab.X - ab.Y * ac.X) / 2),
        r = p - a;

    return (p, Math.Sqrt(r * r));
}

record Vec2d(double X, double Y)
{
    public static Vec2d operator -(Vec2d a, Vec2d b) =>
        new(a.X - b.X, a.Y - b.Y);

    public static double operator *(Vec2d a, Vec2d b) =>
        a.X * b.X + a.Y * b.Y;
}
