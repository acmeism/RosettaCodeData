using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

public class FifteenPuzzle
{
    const int GridSize = 4; //Standard 15 puzzle is 4x4
    const int BlockCount = 16;

    static readonly Random R = new Random();

    private List<Button> Puzzles = new List<Button>();
    private int Moves = 0;
    private DateTime Start;

    public class Puzzle
    {
        private int mOrderedNumer;

        public int CurrentNumber;

        public int X;
        public int Y;

        public int InvX
        {
            get { return (GridSize - 1) - X; }
        }
        public int InvY
        {
            get { return (GridSize - 1) - Y; }
        }

        public Puzzle(int OrderedNumer)
        {
            mOrderedNumer = OrderedNumer;

            CurrentNumber = OrderedNumer;

            X = OrderedNumer % GridSize;
            Y = OrderedNumer / GridSize;
        }
        public Puzzle(int OrderedNumer, int CurrentNumber)
            : this(OrderedNumer)
        {
            this.CurrentNumber = CurrentNumber;
        }

        public bool IsEmptyPuzzle
        {
            get { return CurrentNumber >= (BlockCount - 1); }
        }
        public bool IsTruePlace
        {
            get { return (CurrentNumber == mOrderedNumer); }
        }
        public bool NearestWith(Puzzle OtherPz)
        {
            int dx = (X - OtherPz.X);
            int dy = (Y - OtherPz.Y);

            if ((dx == 0) && (dy <= 1) && (dy >= -1)) return true;
            if ((dy == 0) && (dx <= 1) && (dx >= -1)) return true;

            return false;
        }

        public override string ToString()
        {
            return (CurrentNumber + 1).ToString();
        }
    }

    public static void Main(string[] args)
    {
        FifteenPuzzle Game = new FifteenPuzzle();
        Application.Run(Game.CreateForm());
    }

    private Form CreateForm()
    {
        int ButtonSize = 50;
        int ButtonMargin = 3;
        int FormEdge = 9;

        Font ButtonFont = new Font("Arial", 15.75F, FontStyle.Regular);

        Button StartButton = new Button();
        StartButton.Location = new Point(FormEdge, (GridSize * (ButtonMargin + ButtonSize)) + FormEdge);
        StartButton.Size = new Size(86, 23);
        StartButton.Font = new Font("Arial", 9.75F, FontStyle.Regular);
        StartButton.Text = "New Game";
        StartButton.UseVisualStyleBackColor = true;
        StartButton.TabStop = false;

        StartButton.Click += new EventHandler(NewGame);

        int FormWidth = (GridSize * ButtonSize) + ((GridSize - 1) * ButtonMargin) + (FormEdge * 2);
        int FormHeigth = FormWidth + StartButton.Height;

        Form Form = new Form();
        Form.Text = "Fifteen";
        Form.ClientSize = new Size(FormWidth, FormHeigth);
        Form.FormBorderStyle = FormBorderStyle.FixedSingle;
        Form.MaximizeBox = false;
        Form.SuspendLayout();

        for (int i = 0; i < BlockCount; i++)
        {
            Button Bt = new Button();
            Puzzle Pz = new Puzzle(i);

            int PosX = FormEdge + (Pz.X) * (ButtonSize + ButtonMargin);
            int PosY = FormEdge + (Pz.Y) * (ButtonSize + ButtonMargin);
            Bt.Location = new Point(PosX, PosY);

            Bt.Size = new Size(ButtonSize, ButtonSize);
            Bt.Font = ButtonFont;

            Bt.Text = Pz.ToString();
            Bt.Tag = Pz;
            Bt.UseVisualStyleBackColor = true;
            Bt.TabStop = false;

            Bt.Enabled = false;
            if (Pz.IsEmptyPuzzle) Bt.Visible = false;

            Bt.Click += new EventHandler(MovePuzzle);

            Puzzles.Add(Bt);
            Form.Controls.Add(Bt);
        }

        Form.Controls.Add(StartButton);
        Form.ResumeLayout();

        return Form;
    }

    private void NewGame(object Sender, EventArgs E)
    {
        do
        {
            for (int i = 0; i < Puzzles.Count; i++)
            {
                Button Bt1 = Puzzles[R.Next(i, Puzzles.Count)];
                Button Bt2 = Puzzles[i];
                Swap(Bt1, Bt2);
            }
        }
        while (!IsSolvable());

        for (int i = 0; i < Puzzles.Count; i++)
        {
            Puzzles[i].Enabled = true;
        }

        Moves = 0;
        Start = DateTime.Now;
    }

    private void MovePuzzle(object Sender, EventArgs E)
    {
        Button Bt1 = (Button)Sender;
        Puzzle Pz1 = (Puzzle)Bt1.Tag;

        Button Bt2 = Puzzles.Find(Bt => ((Puzzle)Bt.Tag).IsEmptyPuzzle);
        Puzzle Pz2 = (Puzzle)Bt2.Tag;

        if (Pz1.NearestWith(Pz2))
        {
            Swap(Bt1, Bt2);
            Moves++;
        }

        CheckWin();
    }

    private void CheckWin()
    {
        Button WrongPuzzle = Puzzles.Find(Bt => !((Puzzle)Bt.Tag).IsTruePlace);
        bool UWin = (WrongPuzzle == null);

        if (UWin)
        {
            for (int i = 0; i < Puzzles.Count; i++)
            {
                Puzzles[i].Enabled = false;
            }

            TimeSpan Elapsed = DateTime.Now - Start;
            Elapsed = TimeSpan.FromSeconds(Math.Round(Elapsed.TotalSeconds, 0));
            MessageBox.Show(String.Format("Solved in {0} moves. Time: {1}", Moves, Elapsed));
        }
    }

    private void Swap(Button Bt1, Button Bt2)
    {
        if (Bt1 == Bt2) return;

        Puzzle Pz1 = (Puzzle)Bt1.Tag;
        Puzzle Pz2 = (Puzzle)Bt2.Tag;

        int g = Pz1.CurrentNumber;
        Pz1.CurrentNumber = Pz2.CurrentNumber;
        Pz2.CurrentNumber = g;

        Bt1.Visible = true;
        Bt1.Text = Pz1.ToString();
        if (Pz1.IsEmptyPuzzle) Bt1.Visible = false;

        Bt2.Visible = true;
        Bt2.Text = Pz2.ToString();
        if (Pz2.IsEmptyPuzzle) Bt2.Visible = false;
    }

    private bool IsSolvable()
    {
        // WARNING: size of puzzle board MUST be even(like 4)!
        // For explain see: https://www.geeksforgeeks.org/check-instance-15-puzzle-solvable/

        int InvCount = 0;
        for (int i = 0; i < Puzzles.Count - 1; i++)
        {
            for (int j = i + 1; j < Puzzles.Count; j++)
            {
                Puzzle Pz1 = (Puzzle)Puzzles[i].Tag;
                if (Pz1.IsEmptyPuzzle) continue;

                Puzzle Pz2 = (Puzzle)Puzzles[j].Tag;
                if (Pz2.IsEmptyPuzzle) continue;

                if (Pz1.CurrentNumber > Pz2.CurrentNumber) InvCount++;
            }
        }

        Button EmptyBt = Puzzles.Find(Bt => ((Puzzle)Bt.Tag).IsEmptyPuzzle);
        Puzzle EmptyPz = (Puzzle)EmptyBt.Tag;

        bool Result = false;
        if ((EmptyPz.InvY + 1) % 2 == 0) // is even
        {
            // is odd
            if (InvCount % 2 != 0) Result = true;
        }
        else // is odd
        {
            // is even
            if (InvCount % 2 == 0) Result = true;
        }
        return Result;
    }
}
