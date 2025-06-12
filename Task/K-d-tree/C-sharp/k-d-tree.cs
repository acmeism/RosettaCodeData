using System;
using System.Collections.Generic;
using System.Linq;
using System.Text; // For StringBuilder in Point.ToString

//-----------------------------------------------------------------------------
// Point Struct
//-----------------------------------------------------------------------------

/// <summary>
/// Represents a point in N-dimensional space.
/// TCoord must be a numeric type supporting comparison and conversion.
/// </summary>
/// <typeparam name="TCoord">The numeric type for coordinates (e.g., int, double, float).</typeparam>
public readonly struct Point<TCoord> : IEquatable<Point<TCoord>>
    where TCoord : struct, IComparable<TCoord>, IConvertible // Constraints for numeric operations & sorting
{
    private readonly TCoord[] _coords;
    public int Dimensions { get; }

    /// <summary>
    /// Initializes a new point with the specified coordinates.
    /// The number of coordinates determines the dimension.
    /// </summary>
    /// <param name="coords">The coordinates for the point.</param>
    /// <exception cref="ArgumentNullException">Thrown if coords is null.</exception>
    /// <exception cref="ArgumentException">Thrown if coords is empty.</exception>
    public Point(params TCoord[] coords)
    {
        if (coords == null)
            throw new ArgumentNullException(nameof(coords));
        if (coords.Length == 0)
            throw new ArgumentException("Coordinates cannot be empty.", nameof(coords));

        _coords = (TCoord[])coords.Clone(); // Defensive copy
        Dimensions = _coords.Length;
    }

     /// <summary>
    /// Initializes a new point by copying coordinates from an enumerable.
    /// </summary>
    /// <param name="coords">The coordinates for the point.</param>
    /// <exception cref="ArgumentNullException">Thrown if coords is null.</exception>
    /// <exception cref="ArgumentException">Thrown if coords results in an empty collection.</exception>
    public Point(IEnumerable<TCoord> coords)
    {
        if (coords == null)
            throw new ArgumentNullException(nameof(coords));

        _coords = coords.ToArray();
        if (_coords.Length == 0)
             throw new ArgumentException("Coordinates cannot be empty.", nameof(coords));

        Dimensions = _coords.Length;
    }


    /// <summary>
    /// Gets the coordinate value in the specified dimension.
    /// </summary>
    /// <param name="index">Dimension index (zero-based).</param>
    /// <returns>The coordinate value.</returns>
    /// <exception cref="IndexOutOfRangeException">Thrown if index is out of bounds.</exception>
    public TCoord Get(int index)
    {
        // Rely on array's built-in bounds checking for performance
        // if (index < 0 || index >= Dimensions)
        //     throw new IndexOutOfRangeException($"Index {index} is out of range for dimension {Dimensions}.");
        return _coords[index];
    }

    /// <summary>
    /// Calculates the squared Euclidean distance between this point and another point.
    /// </summary>
    /// <param name="other">The other point.</param>
    /// <returns>The squared distance.</returns>
    /// <exception cref="ArgumentException">Thrown if points have different dimensions.</exception>
    public double DistanceSquared(Point<TCoord> other)
    {
        if (Dimensions != other.Dimensions)
            throw new ArgumentException("Points must have the same dimensions.");

        double distSq = 0;
        for (int i = 0; i < Dimensions; ++i)
        {
            // Convert coordinates to double for calculation.
            // This is a common approach when TCoord isn't guaranteed to be double.
            // Using System.Numerics.INumber<T> in .NET 7+ would allow direct arithmetic.
            double d = Convert.ToDouble(Get(i)) - Convert.ToDouble(other.Get(i));
            distSq += d * d;
        }
        return distSq;
    }

    /// <summary>
    /// Returns a string representation of the point (e.g., "(1, 2, 3)").
    /// </summary>
    public override string ToString()
    {
        var sb = new StringBuilder();
        sb.Append('(');
        for (int i = 0; i < Dimensions; ++i)
        {
            if (i > 0)
                sb.Append(", ");
            sb.Append(_coords[i]);
        }
        sb.Append(')');
        return sb.ToString();
    }

    // --- Equality Members ---
    public bool Equals(Point<TCoord> other)
    {
        if (Dimensions != other.Dimensions)
            return false;
        // Using SequenceEqual for robust array comparison
        return _coords.SequenceEqual(other._coords);
    }

    public override bool Equals(object obj)
    {
        return obj is Point<TCoord> other && Equals(other);
    }

    public override int GetHashCode()
    {
        int hashCode = Dimensions.GetHashCode();
        if (_coords != null)
        {
            foreach (var coord in _coords)
            {
                // Simple hash combining approach
                hashCode = HashCode.Combine(hashCode, coord.GetHashCode());
            }
        }
        return hashCode;
    }

    public static bool operator ==(Point<TCoord> left, Point<TCoord> right)
    {
        return left.Equals(right);
    }

    public static bool operator !=(Point<TCoord> left, Point<TCoord> right)
    {
        return !(left == right);
    }
}


//-----------------------------------------------------------------------------
// KdTree Class
//-----------------------------------------------------------------------------

/// <summary>
/// C# k-d tree implementation for fast nearest neighbor searches.
/// </summary>
/// <typeparam name="TCoord">The numeric type for coordinates.</typeparam>
public class KdTree<TCoord>
    where TCoord : struct, IComparable<TCoord>, IConvertible
{
    // Internal Node class
    private class Node
    {
        public Point<TCoord> Point { get; }
        public Node Left { get; set; } // Using properties with private setters if needed, or public fields
        public Node Right { get; set; }

        public Node(Point<TCoord> point)
        {
            Point = point;
            Left = null;
            Right = null;
        }

        // Helper to access coordinate for sorting/comparison
        public TCoord Get(int index) => Point.Get(index);

        // Helper for distance calculation
        public double DistanceSquared(Point<TCoord> pt) => Point.DistanceSquared(pt);
    }

    // --- Fields ---
    private readonly Node[] _nodes; // Store nodes contiguously for potential cache benefits
    private readonly Node _root;
    private readonly int _dimensions;

    // State for the nearest neighbor search
    private Node _bestNode = null;
    private double _bestDistSq = double.MaxValue;
    private int _visitedCount = 0;


    // --- Comparer for Sorting Nodes ---
    private class NodeComparer : IComparer<Node>
    {
        private readonly int _dimensionIndex;

        public NodeComparer(int dimensionIndex)
        {
            _dimensionIndex = dimensionIndex;
        }

        public int Compare(Node x, Node y)
        {
            // Comparison relies on the IComparable<TCoord> constraint
            return x.Get(_dimensionIndex).CompareTo(y.Get(_dimensionIndex));
        }
    }

    // --- Constructors ---

    /// <summary>
    /// Builds a k-d tree from a collection of points.
    /// </summary>
    /// <param name="points">The points to add to the tree.</param>
    /// <exception cref="ArgumentNullException">Thrown if points is null.</exception>
    /// <exception cref="ArgumentException">Thrown if points is empty or contains points with inconsistent dimensions.</exception>
    public KdTree(IEnumerable<Point<TCoord>> points)
    {
        if (points == null) throw new ArgumentNullException(nameof(points));

        var pointList = points.ToList(); // Materialize the list
        if (pointList.Count == 0) throw new ArgumentException("Point collection cannot be empty.", nameof(points));

        _dimensions = pointList[0].Dimensions;
        _nodes = new Node[pointList.Count];

        for (int i = 0; i < pointList.Count; i++)
        {
            if (pointList[i].Dimensions != _dimensions)
                 throw new ArgumentException($"All points must have the same dimension ({_dimensions}). Point {i} has dimension {pointList[i].Dimensions}.", nameof(points));
            _nodes[i] = new Node(pointList[i]);
        }

        _root = MakeTree(0, _nodes.Length, 0);
    }

    /// <summary>
    /// Builds a k-d tree by generating points using a function.
    /// </summary>
    /// <param name="pointGenerator">A function that returns a Point<TCoord>.</param>
    /// <param name="count">The number of points to generate.</param>
    /// <exception cref="ArgumentNullException">Thrown if pointGenerator is null.</exception>
    /// <exception cref="ArgumentOutOfRangeException">Thrown if count is zero or negative.</exception>
    /// <exception cref="InvalidOperationException">Thrown if the generator produces points with inconsistent dimensions.</exception>
    public KdTree(Func<Point<TCoord>> pointGenerator, int count)
    {
        if (pointGenerator == null) throw new ArgumentNullException(nameof(pointGenerator));
        if (count <= 0) throw new ArgumentOutOfRangeException(nameof(count), "Count must be positive.");

        _nodes = new Node[count];
        Point<TCoord> firstPoint = pointGenerator();
        _dimensions = firstPoint.Dimensions;
        _nodes[0] = new Node(firstPoint);

        for (int i = 1; i < count; i++)
        {
             Point<TCoord> p = pointGenerator();
             if (p.Dimensions != _dimensions)
                 throw new InvalidOperationException($"Generated points must have consistent dimensions ({_dimensions}). Point {i} has dimension {p.Dimensions}.");
            _nodes[i] = new Node(p);
        }

        _root = MakeTree(0, _nodes.Length, 0);
    }


    // --- Tree Building Method ---
    private Node MakeTree(int begin, int end, int index)
    {
        if (end <= begin)
            return null; // Base case: empty range

        // Calculate median index
        int n = begin + (end - begin) / 2;

        // Sort the segment [begin, end) based on the current dimension 'index'
        // This partitions the array around the median element at index 'n'
        // Array.Sort sorts the range [begin, begin + length), so length is end - begin
        Array.Sort(_nodes, begin, end - begin, new NodeComparer(index));

        // Median element becomes the current node
        Node currentNode = _nodes[n];

        // Cycle to the next dimension for children
        int nextIndex = (index + 1) % _dimensions;

        // Recursively build left and right subtrees
        currentNode.Left = MakeTree(begin, n, nextIndex);
        currentNode.Right = MakeTree(n + 1, end, nextIndex);

        return currentNode;
    }

    // --- Public API ---

    /// <summary>
    /// Gets the number of dimensions for points in this tree.
    /// </summary>
    public int Dimensions => _dimensions;

    /// <summary>
    /// Returns true if the tree is empty.
    /// </summary>
    public bool IsEmpty => _nodes.Length == 0;

    /// <summary>
    /// Returns the number of nodes visited during the last call to Nearest.
    /// </summary>
    public int Visited => _visitedCount;

    /// <summary>
    /// Returns the squared distance between the query point and the nearest point found by the last call to Nearest.
    /// Returns double.PositiveInfinity if Nearest hasn't been called or the tree is empty.
    /// </summary>
    public double DistanceSquared => _bestNode != null ? _bestDistSq : double.PositiveInfinity;

    /// <summary>
    /// Returns the Euclidean distance between the query point and the nearest point found by the last call to Nearest.
    /// Returns double.PositiveInfinity if Nearest hasn't been called or the tree is empty.
    /// </summary>
    public double Distance => _bestNode != null ? Math.Sqrt(_bestDistSq) : double.PositiveInfinity;


    /// <summary>
    /// Finds the nearest point in the tree to the given point.
    /// </summary>
    /// <param name="point">The query point.</param>
    /// <returns>The nearest point found in the tree.</returns>
    /// <exception cref="InvalidOperationException">Thrown if the tree is empty.</exception>
    /// <exception cref="ArgumentException">Thrown if the query point has different dimensions than the tree.</exception>
    public Point<TCoord> Nearest(Point<TCoord> point)
    {
        if (_root == null)
            throw new InvalidOperationException("Cannot search an empty tree.");
        if (point.Dimensions != _dimensions)
            throw new ArgumentException($"Query point dimension ({point.Dimensions}) must match tree dimension ({_dimensions}).");

        // Reset search state
        _bestNode = null;
        _bestDistSq = double.MaxValue; // Use MaxValue for initial comparison
        _visitedCount = 0;

        // Start recursive search
        Nearest(_root, point, 0);

        // _bestNode should not be null if _root wasn't null
        return _bestNode.Point;
    }

    // --- Recursive Nearest Neighbor Search ---
    private void Nearest(Node node, Point<TCoord> point, int index)
    {
        if (node == null)
            return;

        _visitedCount++;

        double dSq = node.DistanceSquared(point);

        // If this node is better than the current best, update best
        if (_bestNode == null || dSq < _bestDistSq)
        {
            _bestDistSq = dSq;
            _bestNode = node;
        }

        // Perfect match found, can stop (early exit)
        if (_bestDistSq == 0)
            return;

        // Determine difference along the splitting dimension
        // Convert coordinates to double for the difference calculation
        double dx = Convert.ToDouble(node.Get(index)) - Convert.ToDouble(point.Get(index));

        // Cycle dimension
        int nextIndex = (index + 1) % _dimensions;

        // Decide which subtree to visit first (the one containing the point)
        Node nearerNode = dx > 0 ? node.Left : node.Right;
        Node furtherNode = dx > 0 ? node.Right : node.Left;

        // Search the nearer subtree first
        Nearest(nearerNode, point, nextIndex);

        // Pruning: Check if the hypersphere crosses the splitting plane.
        // If dx^2 >= bestDistSq, the other subtree cannot contain a closer point.
        if (dx * dx >= _bestDistSq)
        {
            return; // Prune the further subtree
        }

        // Hypersphere crosses the plane, search the further subtree
        Nearest(furtherNode, point, nextIndex);
    }
}


//-----------------------------------------------------------------------------
// Example Usage & Testing
//-----------------------------------------------------------------------------
public class Program
{
    static void TestWikipedia()
    {
        Console.WriteLine("Wikipedia example data:");
        var points = new Point<int>[] {
            new Point<int>(2, 3), new Point<int>(5, 4), new Point<int>(9, 6),
            new Point<int>(4, 7), new Point<int>(8, 1), new Point<int>(7, 2)
        };

        var tree = new KdTree<int>(points);

        var queryPoint = new Point<int>(9, 2);
        Point<int> nearest = tree.Nearest(queryPoint);

        Console.WriteLine($"Query point:   {queryPoint}");
        Console.WriteLine($"Nearest point: {nearest}");
        Console.WriteLine($"Distance:      {tree.Distance:F6}"); // Format distance
        Console.WriteLine($"Nodes visited: {tree.Visited}");
        Console.WriteLine("------------------------------------");
    }

    // Simple random point generator for 3D doubles
    private static Random _random = new Random();
    public static Point<double> RandomPointGenerator(double min, double max)
    {
        double range = max - min;
        double x = min + _random.NextDouble() * range;
        double y = min + _random.NextDouble() * range;
        double z = min + _random.NextDouble() * range;
        return new Point<double>(x, y, z);
    }

    static void TestRandom(int count)
    {
        Console.WriteLine($"Random data ({count} points):");

        // Use the generator constructor
        var tree = new KdTree<double>(() => RandomPointGenerator(0, 1), count);

        // Generate a random query point
        var queryPoint = RandomPointGenerator(0, 1);
        Point<double> nearest = tree.Nearest(queryPoint);

        Console.WriteLine($"Query point:    {queryPoint}");
        Console.WriteLine($"Nearest point:  {nearest}");
        Console.WriteLine($"Distance:       {tree.Distance:F6}");
        Console.WriteLine($"Nodes visited:  {tree.Visited}");
        Console.WriteLine("------------------------------------");
    }

    public static void Main(string[] args)
    {
        try
        {
            TestWikipedia();
            TestRandom(1000);
            TestRandom(100000); // Reduced count for faster C# demo
            // TestRandom(1000000); // Can take longer in C# due to sorting overhead vs nth_element
        }
        catch (Exception e)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.Error.WriteLine($"An error occurred: {e.Message}");
            Console.Error.WriteLine(e.StackTrace);
            Console.ResetColor();
        }
    }
}
