using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace CSV
{
    class CSV
    {
        private Dictionary<Tuple<int, int>, string> _data;
        private int _rows;
        private int _cols;

        public int Rows { get { return _rows; } }
        public int Cols { get { return _cols; } }

        public CSV()
        {
            Clear();
        }

        public void Clear()
        {
            _rows = 0;
            _cols = 0;
            _data = new Dictionary<Tuple<int, int>, string>();
        }

        public void Open(StreamReader stream, char delim = ',')
        {
            string line;
            int col = 0;
            int row = 0;

            Clear();

            while ((line = stream.ReadLine()) != null)
            {
                if (line.Length > 0)
                {
                    string[] values = line.Split(delim);
                    col = 0;
                    foreach (var value in values)
                    {
                        this[col,row] = value;
                        col++;
                    }
                    row++;
                }
            }
            stream.Close();
        }

        public void Save(StreamWriter stream, char delim = ',')
        {
            for (int row = 0; row < _rows; row++)
            {
                for (int col = 0; col < _cols; col++)
                {
                    stream.Write(this[col, row]);
                    if (col < _cols - 1)
                    {
                        stream.Write(delim);
                    }
                }
                stream.WriteLine();
            }
            stream.Flush();
            stream.Close();
        }

        public string this[int col, int row]
        {
            get
            {
                try
                {
                    return _data[new Tuple<int, int>(col, row)];
                }
                catch
                {
                    return "";
                }
            }

            set
            {
                _data[new Tuple<int, int>(col, row)] = value.ToString().Trim();
                _rows = Math.Max(_rows, row + 1);
                _cols = Math.Max(_cols, col + 1);
            }
        }

        static void Main(string[] args)
        {
            CSV csv = new CSV();

            csv.Open(new StreamReader(@"test_in.csv"));
            csv[0, 0] = "Column0";
            csv[1, 1] = "100";
            csv[2, 2] = "200";
            csv[3, 3] = "300";
            csv[4, 4] = "400";
            csv.Save(new StreamWriter(@"test_out.csv"));
        }
    }
}
