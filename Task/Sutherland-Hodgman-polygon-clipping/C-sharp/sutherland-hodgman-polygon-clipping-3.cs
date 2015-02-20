using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Sutherland
{
    public partial class MainWindow : Window
    {
        #region Declaration Section

        private Random _rand = new Random();

        private Brush _subjectBack = new SolidColorBrush(ColorFromHex("30427FCF"));
        private Brush _subjectBorder = new SolidColorBrush(ColorFromHex("427FCF"));
        private Brush _clipBack = new SolidColorBrush(ColorFromHex("30D65151"));
        private Brush _clipBorder = new SolidColorBrush(ColorFromHex("D65151"));
        private Brush _intersectBack = new SolidColorBrush(ColorFromHex("609F18CC"));
        private Brush _intersectBorder = new SolidColorBrush(ColorFromHex("9F18CC"));

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();
        }

        #endregion

        #region Event Listeners

        private void btnTriRect_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                double width = canvas.ActualWidth;
                double height = canvas.ActualHeight;

                Point[] poly1 = new Point[] {
				    new Point(_rand.NextDouble() * width, _rand.NextDouble() * height),
				    new Point(_rand.NextDouble() * width, _rand.NextDouble() * height),
				    new Point(_rand.NextDouble() * width, _rand.NextDouble() * height) };

                Point rectPoint = new Point(_rand.NextDouble() * (width * .75d), _rand.NextDouble() * (height * .75d));		//	don't let it start all the way at the bottom right
                Rect rect = new Rect(
                    rectPoint,
                    new Size(_rand.NextDouble() * (width - rectPoint.X), _rand.NextDouble() * (height - rectPoint.Y)));

                Point[] poly2 = new Point[] { rect.TopLeft, rect.TopRight, rect.BottomRight, rect.BottomLeft };

                Point[] intersect = SutherlandHodgman.GetIntersectedPolygon(poly1, poly2);

                canvas.Children.Clear();
                ShowPolygon(poly1, _subjectBack, _subjectBorder, 1d);
                ShowPolygon(poly2, _clipBack, _clipBorder, 1d);
                ShowPolygon(intersect, _intersectBack, _intersectBorder, 3d);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), this.Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void btnConvex_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Point[] poly1 = new Point[] { new Point(50, 150), new Point(200, 50), new Point(350, 150), new Point(350, 300), new Point(250, 300), new Point(200, 250), new Point(150, 350), new Point(100, 250), new Point(100, 200) };
                Point[] poly2 = new Point[] { new Point(100, 100), new Point(300, 100), new Point(300, 300), new Point(100, 300) };

                Point[] intersect = SutherlandHodgman.GetIntersectedPolygon(poly1, poly2);

                canvas.Children.Clear();
                ShowPolygon(poly1, _subjectBack, _subjectBorder, 1d);
                ShowPolygon(poly2, _clipBack, _clipBorder, 1d);
                ShowPolygon(intersect, _intersectBack, _intersectBorder, 3d);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), this.Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void ShowPolygon(Point[] points, Brush background, Brush border, double thickness)
        {
            if (points == null || points.Length == 0)
            {
                return;
            }

            Polygon polygon = new Polygon();
            polygon.Fill = background;
            polygon.Stroke = border;
            polygon.StrokeThickness = thickness;

            foreach (Point point in points)
            {
                polygon.Points.Add(point);
            }

            canvas.Children.Add(polygon);
        }

        /// <summary>
        /// This is just a wrapper to the color converter (why can't they have a method off the color class with all
        /// the others?)
        /// </summary>
        private static Color ColorFromHex(string hexValue)
        {
            if (hexValue.StartsWith("#"))
            {
                return (Color)ColorConverter.ConvertFromString(hexValue);
            }
            else
            {
                return (Color)ColorConverter.ConvertFromString("#" + hexValue);
            }
        }

        #endregion
    }
}
