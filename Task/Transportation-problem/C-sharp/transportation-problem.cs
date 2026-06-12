using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace TransportationProblem {
    class Shipment {
        public Shipment(double q, double cpu, int r, int c) {
            Quantity = q;
            CostPerUnit = cpu;
            R = r;
            C = c;
        }

        public double CostPerUnit { get; }

        public double Quantity { get; set; }

        public int R { get; }

        public int C { get; }
    }

    class Program {
        private static int[] demand;
        private static int[] supply;
        private static double[,] costs;
        private static Shipment[,] matrix;

        static void Init(string filename) {
            string line;
            using (StreamReader file = new StreamReader(filename)) {
                line = file.ReadLine();
                var numArr = line.Split();
                int numSources = int.Parse(numArr[0]);
                int numDestinations = int.Parse(numArr[1]);

                List<int> src = new List<int>();
                List<int> dst = new List<int>();

                line = file.ReadLine();
                numArr = line.Split();
                for (int i = 0; i < numSources; i++) {
                    src.Add(int.Parse(numArr[i]));
                }

                line = file.ReadLine();
                numArr = line.Split();
                for (int i = 0; i < numDestinations; i++) {
                    dst.Add(int.Parse(numArr[i]));
                }

                // fix imbalance
                int totalSrc = src.Sum();
                int totalDst = dst.Sum();
                if (totalSrc > totalDst) {
                    dst.Add(totalSrc - totalDst);
                } else if (totalDst > totalSrc) {
                    src.Add(totalDst - totalSrc);
                }

                supply = src.ToArray();
                demand = dst.ToArray();

                costs = new double[supply.Length, demand.Length];
                matrix = new Shipment[supply.Length, demand.Length];

                for (int i = 0; i < numSources; i++) {
                    line = file.ReadLine();
                    numArr = line.Split();
                    for (int j = 0; j < numDestinations; j++) {
                        costs[i, j] = int.Parse(numArr[j]);
                    }
                }
            }
        }

        static void NorthWestCornerRule() {
            for (int r = 0, northwest = 0; r < supply.Length; r++) {
                for (int c = northwest; c < demand.Length; c++) {
                    int quantity = Math.Min(supply[r], demand[c]);
                    if (quantity > 0) {
                        matrix[r, c] = new Shipment(quantity, costs[r, c], r, c);

                        supply[r] -= quantity;
                        demand[c] -= quantity;

                        if (supply[r] == 0) {
                            northwest = c;
                            break;
                        }
                    }
                }
            }
        }

        static void SteppingStone() {
            double maxReduction = 0;
            Shipment[] move = null;
            Shipment leaving = null;

            FixDegenerateCase();

            for (int r = 0; r < supply.Length; r++) {
                for (int c = 0; c < demand.Length; c++) {
                    if (matrix[r, c] != null) {
                        continue;
                    }

                    Shipment trial = new Shipment(0, costs[r, c], r, c);
                    Shipment[] path = GetClosedPath(trial);

                    double reduction = 0;
                    double lowestQuantity = int.MaxValue;
                    Shipment leavingCandidate = null;

                    bool plus = true;
                    foreach (var s in path) {
                        if (plus) {
                            reduction += s.CostPerUnit;
                        } else {
                            reduction -= s.CostPerUnit;
                            if (s.Quantity < lowestQuantity) {
                                leavingCandidate = s;
                                lowestQuantity = s.Quantity;
                            }
                        }
                        plus = !plus;
                    }
                    if (reduction < maxReduction) {
                        move = path;
                        leaving = leavingCandidate;
                        maxReduction = reduction;
                    }
                }
            }

            if (move != null) {
                double q = leaving.Quantity;
                bool plus = true;
                foreach (var s in move) {
                    s.Quantity += plus ? q : -q;
                    matrix[s.R, s.C] = s.Quantity == 0 ? null : s;
                    plus = !plus;
                }
                SteppingStone();
            }
        }

        static List<Shipment> MatrixToList() {
            List<Shipment> newList = new List<Shipment>();
            foreach (var item in matrix) {
                if (null != item) {
                    newList.Add(item);
                }
            }
            return newList;
        }

        static Shipment[] GetClosedPath(Shipment s) {
            List<Shipment> path = MatrixToList();
            path.Add(s);

            // remove (and keep removing) elements that do not have a
            // vertical AND horizontal neighbor
            int before;
            do {
                before = path.Count;
                path.RemoveAll(ship => {
                    var nbrs = GetNeighbors(ship, path);
                    return nbrs[0] == null || nbrs[1] == null;
                });
            } while (before != path.Count);

            // place the remaining elements in the correct plus-minus order
            Shipment[] stones = path.ToArray();
            Shipment prev = s;
            for (int i = 0; i < stones.Length; i++) {
                stones[i] = prev;
                prev = GetNeighbors(prev, path)[i % 2];
            }
            return stones;
        }

        static Shipment[] GetNeighbors(Shipment s, List<Shipment> lst) {
            Shipment[] nbrs = new Shipment[2];
            foreach (var o in lst) {
                if (o != s) {
                    if (o.R == s.R && nbrs[0] == null) {
                        nbrs[0] = o;
                    } else if (o.C == s.C && nbrs[1] == null) {
                        nbrs[1] = o;
                    }
                    if (nbrs[0] != null && nbrs[1] != null) {
                        break;
                    }
                }
            }
            return nbrs;
        }

        static void FixDegenerateCase() {
            const double eps = double.Epsilon;
            if (supply.Length + demand.Length - 1 != MatrixToList().Count) {
                for (int r = 0; r < supply.Length; r++) {
                    for (int c = 0; c < demand.Length; c++) {
                        if (matrix[r, c] == null) {
                            Shipment dummy = new Shipment(eps, costs[r, c], r, c);
                            if (GetClosedPath(dummy).Length == 0) {
                                matrix[r, c] = dummy;
                                return;
                            }
                        }
                    }
                }
            }
        }

        static void PrintResult(string filename) {
            Console.WriteLine("Optimal solution {0}\n", filename);
            double totalCosts = 0;

            for (int r = 0; r < supply.Length; r++) {
                for (int c = 0; c < demand.Length; c++) {
                    Shipment s = matrix[r, c];
                    if (s != null && s.R == r && s.C == c) {
                        Console.Write(" {0,3} ", s.Quantity);
                        totalCosts += (s.Quantity * s.CostPerUnit);
                    } else {
                        Console.Write("  -  ");
                    }
                }
                Console.WriteLine();
            }
            Console.WriteLine("\nTotal costs: {0}\n", totalCosts);
        }

        static void Main() {
            foreach (var filename in new string[] { "input1.txt", "input2.txt", "input3.txt" }) {
                Init(filename);
                NorthWestCornerRule();
                SteppingStone();
                PrintResult(filename);
            }
        }
    }
}
