Segment Closest_BruteForce(List<PointF> points)
{
    int n = points.Count;
    var result = Enumerable.Range( 0, n-1)
        .SelectMany( i => Enumerable.Range( i+1, n-(i+1) )
            .Select( j => new Segment( points[i], points[j] )))
            .OrderBy( seg => seg.LengthSquared())
            .First();

    return result;
}
