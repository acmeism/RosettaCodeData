        Segment Closest(List<PointF> points)
        {
            Trace.Assert(points.Count >= 2);

            int count = points.Count;
            points.Sort((lhs, rhs) => lhs.X.CompareTo(rhs.X));

            var result = new Segment(points[0], points[1]);
            var bestLength = result.Length();

            for (int i = 0; i < count; i++)
            {
                var from = points[i];

                for (int j = i + 1; j < count; j++)
                {
                    var to = points[j];

                    var dx = to.X - from.X;
                    if (dx >= bestLength)
                    {
                        break;
                    }

                    if (Segment.Length(from, to) < bestLength)
                    {
                        result = new Segment(from, to);
                        bestLength = result.Length();
                    }
                }
            }

            return result;
        }
