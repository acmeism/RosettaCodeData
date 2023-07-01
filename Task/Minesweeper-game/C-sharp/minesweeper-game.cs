using System;
using System.Drawing;
using System.Windows.Forms;

class MineFieldModel
{
    public int RemainingMinesCount{
        get{
            var count = 0;
            ForEachCell((i,j)=>{
                if (Mines[i,j] && !Marked[i,j])
                    count++;
            });
            return count;
        }
    }

    public bool[,] Mines{get; private set;}
    public bool[,] Opened{get;private set;}
    public bool[,] Marked{get; private set;}
    public int[,] Values{get;private set; }
    public int Width{ get{return Mines.GetLength(1);} }
    public int Height{ get{return Mines.GetLength(0);} }

    public MineFieldModel(bool[,] mines)
    {
        this.Mines = mines;
        this.Opened = new bool[Height, Width]; // filled with 'false' by default
        this.Marked = new bool[Height, Width];
        this.Values = CalculateValues();
    }

    private int[,] CalculateValues()
    {
        int[,] values = new int[Height, Width];
        ForEachCell((i,j) =>{
            var value = 0;
            ForEachNeighbor(i,j, (i1,j1)=>{
                if (Mines[i1,j1])
                    value++;
            });
            values[i,j] = value;
        });
        return values;
    }

    // Helper method for iterating over cells
    public void ForEachCell(Action<int,int> action)
    {
        for (var i = 0; i < Height; i++)
        for (var j = 0; j < Width; j++)
            action(i,j);
    }

    // Helper method for iterating over cells' neighbors
    public void ForEachNeighbor(int i, int j, Action<int,int> action)
    {
        for (var i1 = i-1; i1 <= i+1; i1++)
        for (var j1 = j-1; j1 <= j+1; j1++)
            if (InBounds(j1, i1) && !(i1==i && j1 ==j))
                action(i1, j1);
    }

    private bool InBounds(int x, int y)
    {
        return y >= 0 && y < Height && x >=0 && x < Width;
    }

    public event Action Exploded = delegate{};
    public event Action Win = delegate{};
    public event Action Updated = delegate{};

    public void OpenCell(int i, int j){
        if(!Opened[i,j]){
            if (Mines[i,j])
                Exploded();
            else{
                OpenCellsStartingFrom(i,j);
                Updated();
                CheckForVictory();
            }
        }
    }

    void OpenCellsStartingFrom(int i, int j)
    {
            Opened[i,j] = true;
            ForEachNeighbor(i,j, (i1,j1)=>{
                if (!Mines[i1,j1] && !Opened[i1,j1] && !Marked[i1,j1])
                    OpenCellsStartingFrom(i1, j1);
            });
    }

    void CheckForVictory(){
        int notMarked = 0;
        int wrongMarked = 0;
        ForEachCell((i,j)=>{
            if (Mines[i,j] && !Marked[i,j])
                notMarked++;
            if (!Mines[i,j] && Marked[i,j])
                wrongMarked++;
        });
        if (notMarked == 0 && wrongMarked == 0)
            Win();
    }

    public void Mark(int i, int j){
        if (!Opened[i,j])
            Marked[i,j] = true;
            Updated();
            CheckForVictory();
    }
}

class MineFieldView: UserControl{
    public const int CellSize = 40;

    MineFieldModel _model;
    public MineFieldModel Model{
        get{ return _model; }
        set
        {
            _model = value;
            this.Size = new Size(_model.Width * CellSize+1, _model.Height * CellSize+2);
        }
    }

    public MineFieldView(){
        //Enable double-buffering to eliminate flicker
        this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint | ControlStyles.DoubleBuffer,true);
        this.Font = new Font(FontFamily.GenericSansSerif, 14, FontStyle.Bold);

        this.MouseUp += (o,e)=>{
            Point cellCoords = GetCell(e.Location);
            if (Model != null)
            {
                if (e.Button == MouseButtons.Left)
                    Model.OpenCell(cellCoords.Y, cellCoords.X);
                else if (e.Button == MouseButtons.Right)
                    Model.Mark(cellCoords.Y, cellCoords.X);
            }
        };
    }

    Point GetCell(Point coords)
    {
        var rgn = ClientRectangle;
        var x = (coords.X - rgn.X)/CellSize;
        var y = (coords.Y - rgn.Y)/CellSize;
        return new Point(x,y);
    }

    static readonly Brush MarkBrush = new SolidBrush(Color.Blue);
    static readonly Brush ValueBrush = new SolidBrush(Color.Black);
    static readonly Brush UnexploredBrush = new SolidBrush(SystemColors.Control);
    static readonly Brush OpenBrush = new SolidBrush(SystemColors.ControlDark);


    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);
        var g = e.Graphics;
        if (Model != null)
        {
            Model.ForEachCell((i,j)=>
            {
                var bounds = new Rectangle(j * CellSize, i * CellSize, CellSize, CellSize);
                if (Model.Opened[i,j])
                {
                    g.FillRectangle(OpenBrush, bounds);
                    if (Model.Values[i,j] > 0)
                    {
                        DrawStringInCenter(g, Model.Values[i,j].ToString(), ValueBrush, bounds);
                    }
                }
                else
                {
                    g.FillRectangle(UnexploredBrush, bounds);
                    if (Model.Marked[i,j])
                    {
                        DrawStringInCenter(g, "?", MarkBrush, bounds);
                    }
                    var outlineOffset = 1;
                    var outline = new Rectangle(bounds.X+outlineOffset, bounds.Y+outlineOffset, bounds.Width-2*outlineOffset, bounds.Height-2*outlineOffset);
                    g.DrawRectangle(Pens.Gray, outline);
                }
                g.DrawRectangle(Pens.Black, bounds);
            });
        }

    }

    static readonly StringFormat FormatCenter = new StringFormat
                            {
                                LineAlignment = StringAlignment.Center,
                                Alignment=StringAlignment.Center
                            };

    void DrawStringInCenter(Graphics g, string s, Brush brush, Rectangle bounds)
    {
        PointF center = new PointF(bounds.X + bounds.Width/2, bounds.Y + bounds.Height/2);
        g.DrawString(s, this.Font, brush, center, FormatCenter);
    }

}

class MineSweepForm: Form
{

    MineFieldModel CreateField(int width, int height)
{
        var field = new bool[height, width];
        int mineCount = (int)(0.2 * height * width);
        var rnd = new Random();
        while(mineCount > 0)
        {
            var x = rnd.Next(width);
            var y = rnd.Next(height);
            if (!field[y,x])
            {
                field[y,x] = true;
                mineCount--;
            }
        }
        return new MineFieldModel(field);
    }

    public MineSweepForm()
    {
        var model = CreateField(6, 4);
        var counter = new Label{ };
        counter.Text = model.RemainingMinesCount.ToString();
        var view = new MineFieldView
                        {
                            Model = model, BorderStyle = BorderStyle.FixedSingle,
                        };
        var stackPanel = new FlowLayoutPanel
                        {
                            Dock = DockStyle.Fill,
                            FlowDirection = FlowDirection.TopDown,
                            Controls = {counter, view}
                        };
        this.Controls.Add(stackPanel);
        model.Updated += delegate{
            view.Invalidate();
            counter.Text = model.RemainingMinesCount.ToString();
        };
        model.Exploded += delegate {
            MessageBox.Show("FAIL!");
            Close();
        };
        model.Win += delegate {
            MessageBox.Show("WIN!");
            view.Enabled = false;
        };

    }
}

class Program
{
    static void Main()
    {
        Application.Run(new MineSweepForm());
    }
}
