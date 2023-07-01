class Segment
{
    public Segment(PointF p1, PointF p2)
    {
        P1 = p1;
        P2 = p2;
    }

    public readonly PointF P1;
    public readonly PointF P2;

    public float Length()
    {
        return (float)Math.Sqrt(LengthSquared());
    }

    public float LengthSquared()
    {
        return (P1.X - P2.X) * (P1.X - P2.X)
            + (P1.Y - P2.Y) * (P1.Y - P2.Y);
    }
}
