using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Threading;
using System.Windows.Forms;

namespace ForestFire
{
    class Program : Form
    {
        private static readonly Random rand = new Random();
        private Bitmap img;

        public Program(int w, int h, int f, int p)
        {
            Size = new Size(w, h);
            StartPosition = FormStartPosition.CenterScreen;

            Thread t = new Thread(() => fire(f, p));
            t.Start();

            FormClosing += (object sender, FormClosingEventArgs e) => { t.Abort(); t = null; };
        }

        private void fire(int f, int p)
        {
            int clientWidth = ClientRectangle.Width;
            int clientHeight = ClientRectangle.Height;
            int cellSize = 10;

            img = new Bitmap(clientWidth, clientHeight);
            Graphics g = Graphics.FromImage(img);

            CellState[,] state = InitializeForestFire(clientWidth, clientHeight);

            uint generation = 0;

            do
            {
                g.FillRectangle(Brushes.White, 0, 0, img.Width, img.Height);
                state = StepForestFire(state, f, p);

                for (int y = 0; y < clientHeight - cellSize; y += cellSize)
                {
                    for (int x = 0; x < clientWidth - cellSize; x += cellSize)
                    {
                        switch (state[y, x])
                        {
                            case CellState.Empty:
                                break;
                            case CellState.Tree:
                                g.FillRectangle(Brushes.DarkGreen, x, y, cellSize, cellSize);
                                break;
                            case CellState.Burning:
                                g.FillRectangle(Brushes.DarkRed, x, y, cellSize, cellSize);
                                break;
                        }
                    }
                }

                Thread.Sleep(500);

                Invoke((MethodInvoker)Refresh);

            } while (generation < uint.MaxValue);

            g.Dispose();
        }

        private CellState[,] InitializeForestFire(int width, int height)
        {
            // Create our state array, initialize all indices as Empty, and return it.
            var state = new CellState[height, width];
            state.Initialize();
            return state;
        }

        private enum CellState : byte
        {
            Empty = 0,
            Tree = 1,
            Burning = 2
        }

        private CellState[,] StepForestFire(CellState[,] state, int f, int p)
        {
            /* Clone our old state, so we can write to our new state
             * without changing any values in the old state. */
            var newState = (CellState[,])state.Clone();

            int numRows = state.GetLength(0);
            int numCols = state.GetLength(1);

            for (int r = 1; r < numRows - 1; r++)
            {
                for (int c = 1; c < numCols - 1; c++)
                {
                    /*
                     * Check the current cell.
                     *
                     * If it's empty, give it a 1/p chance of becoming a tree.
                     *
                     * If it's a tree, check to see if any neighbors are burning.
                     * If so, set the cell's state to burning, otherwise give it
                     * a 1/f chance of combusting.
                     *
                     * If it's burning, set it to empty.
                     */
                    switch (state[r, c])
                    {
                        case CellState.Empty:
                            if (rand.Next(0, p) == 0)
                                newState[r, c] = CellState.Tree;
                            break;

                        case CellState.Tree:
                            if (NeighborHasState(state, r, c, CellState.Burning) || rand.Next(0, f) == 0)
                                newState[r, c] = CellState.Burning;
                            break;

                        case CellState.Burning:
                            newState[r, c] = CellState.Empty;
                            break;
                    }
                }
            }

            return newState;
        }

        private bool NeighborHasState(CellState[,] state, int x, int y, CellState value)
        {
            // Check each cell within a 1 cell radius for the specified value.
            for (int r = -1; r <= 1; r++)
            {
                for (int c = -1; c <= 1; c++)
                {
                    if (r == 0 && c == 0)
                        continue;

                    if (state[x + r, y + c] == value)
                        return true;
                }
            }

            return false;
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            e.Graphics.DrawImage(img, 0, 0);
        }

        [STAThread]
        static void Main(string[] args)
        {
            Application.Run(new Program(w: 500, h: 500, f: 2, p: 5));
        }
    }
}
