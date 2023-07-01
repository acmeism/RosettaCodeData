using System;
using System.Collections.Generic;

namespace ResistorMesh {
    class Node {
        public Node(double v, int fixed_) {
            V = v;
            Fixed = fixed_;
        }

        public double V { get; set; }
        public int Fixed { get; set; }
    }

    class Program {
        static void SetBoundary(List<List<Node>> m) {
            m[1][1].V = 1.0;
            m[1][1].Fixed = 1;

            m[6][7].V = -1.0;
            m[6][7].Fixed = -1;
        }

        static double CalcuateDifference(List<List<Node>> m, List<List<Node>> d, int w, int h) {
            double total = 0.0;
            for (int i = 0; i < h; i++) {
                for (int j = 0; j < w; j++) {
                    double v = 0.0;
                    int n = 0;
                    if (i > 0) {
                        v += m[i - 1][j].V;
                        n++;
                    }
                    if (j > 0) {
                        v += m[i][j - 1].V;
                        n++;
                    }
                    if (i + 1 < h) {
                        v += m[i + 1][j].V;
                        n++;
                    }
                    if (j + 1 < w) {
                        v += m[i][j + 1].V;
                        n++;
                    }
                    v = m[i][j].V - v / n;
                    d[i][j].V = v;
                    if (m[i][j].Fixed == 0) {
                        total += v * v;
                    }
                }
            }
            return total;
        }

        static double Iter(List<List<Node>> m, int w, int h) {
            List<List<Node>> d = new List<List<Node>>(h);
            for (int i = 0; i < h; i++) {
                List<Node> t = new List<Node>(w);
                for (int j = 0; j < w; j++) {
                    t.Add(new Node(0.0, 0));
                }
                d.Add(t);
            }

            double[] curr = new double[3];
            double diff = 1e10;

            while (diff > 1e-24) {
                SetBoundary(m);
                diff = CalcuateDifference(m, d, w, h);
                for (int i = 0; i < h; i++) {
                    for (int j = 0; j < w; j++) {
                        m[i][j].V -= d[i][j].V;
                    }
                }
            }

            for (int i = 0; i < h; i++) {
                for (int j = 0; j < w; j++) {
                    int k = 0;
                    if (i != 0) k++;
                    if (j != 0) k++;
                    if (i < h - 1) k++;
                    if (j < w - 1) k++;
                    curr[m[i][j].Fixed + 1] += d[i][j].V * k;
                }
            }

            return (curr[2] - curr[0]) / 2.0;
        }

        const int S = 10;
        static void Main(string[] args) {
            List<List<Node>> mesh = new List<List<Node>>(S);
            for (int i = 0; i < S; i++) {
                List<Node> t = new List<Node>(S);
                for (int j = 0; j < S; j++) {
                    t.Add(new Node(0.0, 0));
                }
                mesh.Add(t);
            }

            double r = 2.0 / Iter(mesh, S, S);
            Console.WriteLine("R = {0:F15}", r);
        }
    }
}
