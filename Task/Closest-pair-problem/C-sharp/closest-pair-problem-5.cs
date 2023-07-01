        Segment Closest_BruteForce(List<PointF> points)
        {
            Trace.Assert(points.Count >= 2);

            int count = points.Count;

            // Seed the result - doesn't matter what points are used
            // This just avoids having to do null checks in the main loop below
            var result = new Segment(points[0], points[1]);
            var bestLength = result.Length();

            for (int i = 0; i < count; i++)
                for (int j = i + 1; j < count; j++)
                    if (Segment.Length(points[i], points[j]) < bestLength)
                    {
                        result = new Segment(points[i], points[j]);
                        bestLength = result.Length();
                    }

            return result;
        }
