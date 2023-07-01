public class Bitmap
{
    public struct Color
    {
        public byte Red { get; set; }
        public byte Blue { get; set; }
        public byte Green { get; set; }
    }
    Color[,] _imagemap;
    public int Width { get { return _imagemap.GetLength(0); } }
    public int Height { get { return _imagemap.GetLength(1); } }
    public Bitmap(int width, int height)
    {
        _imagemap = new Color[width, height];
    }
    public void Fill(Color color)
    {
        for (int y = 0; y < Height; y++)
            for (int x = 0; x < Width; x++)
            {
                _imagemap[x, y] = color;
            }
    }
    public Color GetPixel(int x, int y)
    {
        return _imagemap[x, y];
    }
    public void SetPixel(int x, int y, Color color)
    {
        _imagemap[x, y] = color;
    }
}
