using System;

namespace LangtonAnt
{
    public struct Point
    {
        public int X;
        public int Y;

        public Point(int x, int y)
        {
            X = x;
            Y = y;
        }
    }

    enum Direction
    {
        North, East, West, South
    }

    public class Langton
    {
        public readonly bool [,] IsBlack;
        private Point _origin;
        private Point _antPosition = new Point(0, 0);
        public bool OutOfBounds { get; set;}

        // I don't see any mention of what direction the ant is supposed to start out in
        private Direction _antDirection = Direction.East;

        private readonly Direction[] _leftTurn = new[] { Direction.West, Direction.North, Direction.South, Direction.East };
        private readonly Direction[] _rightTurn = new[] { Direction.East, Direction.South, Direction.North, Direction.West };
        private readonly int[] _xInc = new[] { 0, 1,-1, 0};
        private readonly int[] _yInc = new[] {-1, 0, 0, 1};

        public Langton(int width, int height, Point origin)
        {
            _origin = origin;
            IsBlack = new bool[width, height];
            OutOfBounds = false;
        }

        public Langton(int width, int height) : this(width, height, new Point(width / 2, height / 2)) {}

        private void MoveAnt()
        {
            _antPosition.X += _xInc[(int)_antDirection];
            _antPosition.Y += _yInc[(int)_antDirection];
        }

        public Point Step()
        {
            if (OutOfBounds)
            {
                throw new InvalidOperationException("Trying to step after ant is out of bounds");
            }
            Point ptCur = new Point(_antPosition.X + _origin.X, _antPosition.Y + _origin.Y);
            bool leftTurn = IsBlack[ptCur.X, ptCur.Y];
            int iDirection = (int) _antDirection;
            _antDirection = leftTurn ? _leftTurn[iDirection] : _rightTurn[iDirection];
            IsBlack[ptCur.X, ptCur.Y] = !IsBlack[ptCur.X, ptCur.Y];
            MoveAnt();
            ptCur = new Point(_antPosition.X + _origin.X, _antPosition.Y + _origin.Y);
            OutOfBounds =
                ptCur.X < 0 ||
                ptCur.X >= IsBlack.GetUpperBound(0) ||
                ptCur.Y < 0 ||
                ptCur.Y >= IsBlack.GetUpperBound(1);
            return _antPosition;
        }
    }
    class Program
    {
        static void Main()
        {
            Langton ant = new Langton(100, 100);

            while (!ant.OutOfBounds) ant.Step();

            for (int iRow = 0; iRow < 100; iRow++)
            {
                for (int iCol = 0; iCol < 100; iCol++)
                {
                    Console.Write(ant.IsBlack[iCol, iRow] ? "#" : " ");
                }
                Console.WriteLine();
            }

            Console.ReadKey();
        }
    }
}
