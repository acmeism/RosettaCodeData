public static Segment MyClosestDivide(List<PointF> points)
{
   return MyClosestRec(points.OrderBy(p => p.X).ToList());
}

private static Segment MyClosestRec(List<PointF> pointsByX)
{
   int count = pointsByX.Count;
   if (count <= 4)
      return Closest_BruteForce(pointsByX);

   // left and right lists sorted by X, as order retained from full list
   var leftByX = pointsByX.Take(count/2).ToList();
   var leftResult = MyClosestRec(leftByX);

   var rightByX = pointsByX.Skip(count/2).ToList();
   var rightResult = MyClosestRec(rightByX);

   var result = rightResult.Length() < leftResult.Length() ? rightResult : leftResult;

   // There may be a shorter distance that crosses the divider
   // Thus, extract all the points within result.Length either side
   var midX = leftByX.Last().X;
   var bandWidth = result.Length();
   var inBandByX = pointsByX.Where(p => Math.Abs(midX - p.X) <= bandWidth);

   // Sort by Y, so we can efficiently check for closer pairs
   var inBandByY = inBandByX.OrderBy(p => p.Y).ToArray();

   int iLast = inBandByY.Length - 1;
   for (int i = 0; i < iLast; i++ )
   {
      var pLower = inBandByY[i];

      for (int j = i + 1; j <= iLast; j++)
      {
         var pUpper = inBandByY[j];

         // Comparing each point to successivly increasing Y values
         // Thus, can terminate as soon as deltaY is greater than best result
         if ((pUpper.Y - pLower.Y) >= result.Length())
            break;

         if (Segment.Length(pLower, pUpper) < result.Length())
            result = new Segment(pLower, pUpper);
      }
   }

   return result;
}
