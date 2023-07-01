using System;
using System.Collections.Generic;
using System.Linq;

namespace RankingMethods {
    class Program {
        static void Main(string[] args) {
            Dictionary<string, int> scores = new Dictionary<string, int> {
                ["Solomon"] = 44,
                ["Jason"] = 42,
                ["Errol"] = 42,
                ["Gary"] = 41,
                ["Bernard"] = 41,
                ["Barry"] = 41,
                ["Stephen"] = 39,
            };

            StandardRank(scores);
            ModifiedRank(scores);
            DenseRank(scores);
            OrdinalRank(scores);
            FractionalRank(scores);
        }

        static void StandardRank(Dictionary<string, int> data) {
            Console.WriteLine("Standard Rank");

            var list = data.Values.Distinct().ToList();
            list.Sort((a, b) => b.CompareTo(a));

            int rank = 1;
            foreach (var value in list) {
                int temp = rank;
                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        Console.WriteLine("{0} {1} {2}", temp, value, k);
                        rank++;
                    }
                }
            }

            Console.WriteLine();
        }

        static void ModifiedRank(Dictionary<string, int> data) {
            Console.WriteLine("Modified Rank");

            var list = data.Values.Distinct().ToList();
            list.Sort((a, b) => b.CompareTo(a));

            int rank = 0;
            foreach (var value in list) {
                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        rank++;
                    }
                }

                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        Console.WriteLine("{0} {1} {2}", rank, data[k], k);
                    }
                }
            }

            Console.WriteLine();
        }

        static void DenseRank(Dictionary<string, int> data) {
            Console.WriteLine("Dense Rank");

            var list = data.Values.Distinct().ToList();
            list.Sort((a, b) => b.CompareTo(a));

            int rank = 1;
            foreach (var value in list) {
                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        Console.WriteLine("{0} {1} {2}", rank, data[k], k);
                    }
                }
                rank++;
            }

            Console.WriteLine();
        }

        static void OrdinalRank(Dictionary<string, int> data) {
            Console.WriteLine("Ordinal Rank");

            var list = data.Values.Distinct().ToList();
            list.Sort((a, b) => b.CompareTo(a));

            int rank = 1;
            foreach (var value in list) {
                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        Console.WriteLine("{0} {1} {2}", rank, data[k], k);
                        rank++;
                    }
                }
            }

            Console.WriteLine();
        }

        static void FractionalRank(Dictionary<string, int> data) {
            Console.WriteLine("Fractional Rank");

            var list = data.Values.Distinct().ToList();
            list.Sort((a, b) => b.CompareTo(a));

            int rank = 0;
            foreach (var value in list) {
                double avg = 0;
                int cnt = 0;

                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        rank++;
                        cnt++;
                        avg += rank;
                    }
                }
                avg /= cnt;

                foreach (var k in data.Keys) {
                    if (data[k] == value) {
                        Console.WriteLine("{0:F1} {1} {2}", avg, data[k], k);
                    }
                }
            }

            Console.WriteLine();
        }
    }
}
