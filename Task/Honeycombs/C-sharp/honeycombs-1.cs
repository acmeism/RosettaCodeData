using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;

////////////////////////////////////////////////////////////////////////////////////////////////////
// namespace: Honeycombs
//
// summary:	WPF implementation of Rosetta Code Honeycombs task.  Uses Polygon shapes as hexes.
////////////////////////////////////////////////////////////////////////////////////////////////////

namespace Honeycombs
{
    public partial class MainWindow
    {
        private const int RowCount = 4;
        private const int ColCount = 5;
        private const int LabelSize = 20;
        private readonly char[] _permutedChars;

        public MainWindow()
        {
            if (RowCount * ColCount > 26)
#pragma warning disable 162
            {
                throw new ArgumentException("Too many cells");
            }
#pragma warning restore 162
            _permutedChars = GetPermutedChars(RowCount * ColCount);

            // VS Generated code not included
            InitializeComponent();
        }

        private static char[] GetPermutedChars(int characterCount)
        {
            const string allChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            var rnd = new Random();
            var chars = new char[allChars.Length];

            for (int i = 0; i < allChars.Length; i++)
            {
                chars[i] = allChars[i];
            }

            for (int i = 0; i < characterCount; i++)
            {
                int swapIndex = rnd.Next() % (allChars.Length - i);
                char tmp = chars[swapIndex + i];
                chars[swapIndex + i] = chars[i];
                chars[i] = tmp;
            }
            return chars;
        }

        private void SetHexProperties(UIElementCollection hexes, double cellSize)
        {
            int charIndex = 0;
            List<Polygon> hexList = hexes.Cast<Polygon>().ToList();

            foreach (Polygon element in hexList)
            {
                SetHexProperties(element, _permutedChars[charIndex++], cellSize);
            }
        }

        private void SetHexProperties(Polygon hex, char charToSet, double cellSize)
        {
            var tag = (Tuple<int, int, double, double>) hex.Tag;
            double cellX = tag.Item3;
            double cellY = tag.Item4;

            // We place the text in a grid centered on the hex.
            // The grid will then center the text within itself.

            var centeringGrid = new Grid();
            centeringGrid.Width = centeringGrid.Height = 2 * cellSize;
            centeringGrid.SetValue(Canvas.LeftProperty, cellX - cellSize);
            centeringGrid.SetValue(Canvas.TopProperty, cellY - cellSize);
            centeringGrid.IsHitTestVisible = false;
            HoneycombCanvas.Children.Add(centeringGrid);

            var label = new TextBlock
                {
                    Text = new string(charToSet, 1),
                    FontFamily = new FontFamily("Segoe"),
                    FontSize = LabelSize
                };
            label.HorizontalAlignment = HorizontalAlignment.Center;
            label.VerticalAlignment = VerticalAlignment.Center;
            label.IsHitTestVisible = false;
            centeringGrid.Children.Add(label);

            // Reset the tag to keep track of the character in the hex
            hex.Tag = charToSet;
            hex.Fill = new SolidColorBrush(Colors.Yellow);
            hex.Stroke = new SolidColorBrush(Colors.Black);
            hex.StrokeThickness = cellSize / 10;

            // Mouse down event handler for the hex
            hex.MouseDown += hex_MouseDown;
        }

        private void hex_MouseDown(object sender, MouseButtonEventArgs e)
        {
            var hex = sender as Shape;
            if (hex == null)
            {
                throw new InvalidCastException("Non-shape in Honeycomb");
            }

            // Get the letter for this hex
            var ch = (char) hex.Tag;

            // Add it to our Letters TextBlock
            Letters.Text = Letters.Text + ch;

            // Color the hex magenta
            hex.Fill = new SolidColorBrush(Colors.Magenta);

            // Remove the mouse down event handler so we won't hit on this hex again
            hex.MouseDown -= hex_MouseDown;
        }

        private static void GetCombSize(double actualHeight, double actualWidth, int columns, int rows,
                                        out double cellSize, out double combHeight, out double combWidth)
        {
            double columnFactor = (3 * columns + 1) / 2.0;
            double rowFactor = (Math.Sqrt(3) * (2 * rows + 1)) / 2.0;
            double cellFromWidth = actualWidth / columnFactor;
            double cellFromHeight = actualHeight / rowFactor;
            cellSize = Math.Min(cellFromWidth, cellFromHeight);
            combWidth = cellSize * columnFactor;
            combHeight = cellSize * rowFactor;
        }

        private static void AddCells(Canvas canvas, double cellSize, int columns, int rows)
        {
            double rowHeight = cellSize * Math.Sqrt(3) / 2;

            for (int row = 0; row < rows; row++)
            {
                AddRow(rowHeight, canvas, cellSize, columns, row);
                rowHeight += cellSize * Math.Sqrt(3);
            }
        }

        private static void AddRow(double rowHeight, Canvas canvas, double cellSize, int columnCount, int row)
        {
            double cellX = cellSize;
            double cellHeight = cellSize * Math.Sqrt(3);

            for (int col = 0; col < columnCount; col++)
            {
                double cellY = rowHeight + ((col & 1) == 1 ? cellHeight / 2 : 0);
                Polygon hex = GetCenteredHex(cellSize, cellX, cellY, cellHeight);
                hex.Tag = Tuple.Create(col, row, cellX, cellY);
                canvas.Children.Add(hex);
                cellX += 3 * cellSize / 2;
            }
        }

        private static Polygon GetCenteredHex(double cellSize, double cellX, double cellY, double cellHeight)
        {
            var hex = new Polygon();
            hex.Points.Add(new Point(cellX - cellSize, cellY));
            hex.Points.Add(new Point(cellX - cellSize / 2, cellY + cellHeight / 2));
            hex.Points.Add(new Point(cellX + cellSize / 2, cellY + cellHeight / 2));
            hex.Points.Add(new Point(cellX + cellSize, cellY));
            hex.Points.Add(new Point(cellX + cellSize / 2, cellY - cellHeight / 2));
            hex.Points.Add(new Point(cellX - cellSize / 2, cellY - cellHeight / 2));
            return hex;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            double combHeight, combWidth, cellSize;

            // Get sizes that will fit within our window
            GetCombSize(Main.ActualHeight, Main.ActualWidth, ColCount, RowCount, out cellSize, out combHeight,
                        out combWidth);

            // Set the canvas size appropriately
            HoneycombCanvas.Width = combWidth;
            HoneycombCanvas.Height = combHeight;

            // Add the cells to the canvas
            AddCells(HoneycombCanvas, cellSize, ColCount, RowCount);

            // Set the cells to look like we want them
            SetHexProperties(HoneycombCanvas.Children, cellSize);
        }
    }
}
