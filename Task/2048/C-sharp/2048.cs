using System;

namespace g2048_csharp
{
    internal class Tile
    {
        public Tile()
        {
            Value = 0;
            IsBlocked = false;
        }

        public int Value { get; set; }
        public bool IsBlocked { get; set; }
    }

    internal enum MoveDirection
    {
        Up,
        Down,
        Left,
        Right
    }

    internal class G2048
    {
        public G2048()
        {
            _isDone = false;
            _isWon = false;
            _isMoved = true;
            _score = 0;
            InitializeBoard();
        }

        private void InitializeBoard()
        {
            for (int y = 0; y < 4; y++)
            {
                for (int x = 0; x < 4; x++)
                {
                    _board[x, y] = new Tile();
                }
            }
        }

        private bool _isDone;
        private bool _isWon;
        private bool _isMoved;
        private int _score;
        private readonly Tile[,] _board = new Tile[4, 4];
        private readonly Random _rand = new Random();

        public void Loop()
        {
            AddTile();
            while (true)
            {
                if (_isMoved)
                {
                    AddTile();
                }

                DrawBoard();
                if (_isDone)
                {
                    break;
                }

                WaitKey();
            }

            string endMessage = _isWon ? "You've made it!" : "Game Over!";
            Console.WriteLine(endMessage);
        }

        private void DrawBoard()
        {
            Console.Clear();
            Console.WriteLine("Score: " + _score + "\n");
            for (int y = 0; y < 4; y++)
            {
                Console.WriteLine("+------+------+------+------+");
                Console.Write("| ");
                for (int x = 0; x < 4; x++)
                {
                    if (_board[x, y].Value == 0)
                    {
                        const string empty = " ";
                        Console.Write(empty.PadRight(4));
                    }
                    else
                    {
                        Console.Write(_board[x, y].Value.ToString().PadRight(4));
                    }

                    Console.Write(" | ");
                }

                Console.WriteLine();
            }

            Console.WriteLine("+------+------+------+------+\n\n");
        }

        private void WaitKey()
        {
            _isMoved = false;
            Console.WriteLine("(W) Up (S) Down (A) Left (D) Right");
            char input;
            char.TryParse(Console.ReadKey().Key.ToString(), out input);

            switch (input)
            {
                case 'W':
                    Move(MoveDirection.Up);
                    break;
                case 'A':
                    Move(MoveDirection.Left);
                    break;
                case 'S':
                    Move(MoveDirection.Down);
                    break;
                case 'D':
                    Move(MoveDirection.Right);
                    break;
            }

            for (int y = 0; y < 4; y++)
            {
                for (int x = 0; x < 4; x++)
                {
                    _board[x, y].IsBlocked = false;
                }
            }
        }

        private void AddTile()
        {
            for (int y = 0; y < 4; y++)
            {
                for (int x = 0; x < 4; x++)
                {
                    if (_board[x, y].Value != 0) continue;
                    int a, b;
                    do
                    {
                        a = _rand.Next(0, 4);
                        b = _rand.Next(0, 4);
                    } while (_board[a, b].Value != 0);

                    double r = _rand.NextDouble();
                    _board[a, b].Value = r > 0.89f ? 4 : 2;

                    if (CanMove())
                    {
                        return;
                    }
                }
            }

            _isDone = true;
        }

        private bool CanMove()
        {
            for (int y = 0; y < 4; y++)
            {
                for (int x = 0; x < 4; x++)
                {
                    if (_board[x, y].Value == 0)
                    {
                        return true;
                    }
                }
            }

            for (int y = 0; y < 4; y++)
            {
                for (int x = 0; x < 4; x++)
                {
                    if (TestAdd(x + 1, y, _board[x, y].Value)
                        || TestAdd(x - 1, y, _board[x, y].Value)
                        || TestAdd(x, y + 1, _board[x, y].Value)
                        || TestAdd(x, y - 1, _board[x, y].Value))
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        private bool TestAdd(int x, int y, int value)
        {
            if (x < 0 || x > 3 || y < 0 || y > 3)
            {
                return false;
            }

            return _board[x, y].Value == value;
        }

        private void MoveVertically(int x, int y, int d)
        {
            if (_board[x, y + d].Value != 0
                && _board[x, y + d].Value == _board[x, y].Value
                && !_board[x, y].IsBlocked
                && !_board[x, y + d].IsBlocked)
            {
                _board[x, y].Value = 0;
                _board[x, y + d].Value *= 2;
                _score += _board[x, y + d].Value;
                _board[x, y + d].IsBlocked = true;
                _isMoved = true;
            }
            else if (_board[x, y + d].Value == 0
                     && _board[x, y].Value != 0)
            {
                _board[x, y + d].Value = _board[x, y].Value;
                _board[x, y].Value = 0;
                _isMoved = true;
            }

            if (d > 0)
            {
                if (y + d < 3)
                {
                    MoveVertically(x, y + d, 1);
                }
            }
            else
            {
                if (y + d > 0)
                {
                    MoveVertically(x, y + d, -1);
                }
            }
        }

        private void MoveHorizontally(int x, int y, int d)
        {
            if (_board[x + d, y].Value != 0
                && _board[x + d, y].Value == _board[x, y].Value
                && !_board[x + d, y].IsBlocked
                && !_board[x, y].IsBlocked)
            {
                _board[x, y].Value = 0;
                _board[x + d, y].Value *= 2;
                _score += _board[x + d, y].Value;
                _board[x + d, y].IsBlocked = true;
                _isMoved = true;
            }
            else if (_board[x + d, y].Value == 0
                     && _board[x, y].Value != 0)
            {
                _board[x + d, y].Value = _board[x, y].Value;
                _board[x, y].Value = 0;
                _isMoved = true;
            }

            if (d > 0)
            {
                if (x + d < 3)
                {
                    MoveHorizontally(x + d, y, 1);
                }
            }
            else
            {
                if (x + d > 0)
                {
                    MoveHorizontally(x + d, y, -1);
                }
            }
        }

        private void Move(MoveDirection direction)
        {
            switch (direction)
            {
                case MoveDirection.Up:
                    for (int x = 0; x < 4; x++)
                    {
                        int y = 1;
                        while (y < 4)
                        {
                            if (_board[x, y].Value != 0)
                            {
                                MoveVertically(x, y, -1);
                            }

                            y++;
                        }
                    }

                    break;
                case MoveDirection.Down:
                    for (int x = 0; x < 4; x++)
                    {
                        int y = 2;
                        while (y >= 0)
                        {
                            if (_board[x, y].Value != 0)
                            {
                                MoveVertically(x, y, 1);
                            }

                            y--;
                        }
                    }

                    break;
                case MoveDirection.Left:
                    for (int y = 0; y < 4; y++)
                    {
                        int x = 1;
                        while (x < 4)
                        {
                            if (_board[x, y].Value != 0)
                            {
                                MoveHorizontally(x, y, -1);
                            }

                            x++;
                        }
                    }

                    break;
                case MoveDirection.Right:
                    for (int y = 0; y < 4; y++)
                    {
                        int x = 2;
                        while (x >= 0)
                        {
                            if (_board[x, y].Value != 0)
                            {
                                MoveHorizontally(x, y, 1);
                            }

                            x--;
                        }
                    }

                    break;
            }
        }
    }

    internal static class Program
    {
        public static void Main(string[] args)
        {
            RunGame();
        }

        private static void RunGame()
        {
            G2048 game = new G2048();
            game.Loop();

            CheckRestart();
        }

        private static void CheckRestart()
        {
            Console.WriteLine("(N) New game (P) Exit");
            while (true)
            {
                char input;
                char.TryParse(Console.ReadKey().Key.ToString(), out input);
                switch (input)
                {
                    case 'N':
                        RunGame();
                        break;
                    case 'P':
                        return;
                    default:
                        ClearLastLine();
                        break;
                }
            }
        }

        private static void ClearLastLine()
        {
            Console.SetCursorPosition(0, Console.CursorTop);
            Console.Write(new string(' ', Console.BufferWidth));
            Console.SetCursorPosition(0, Console.CursorTop - 1);
        }
    }
}
