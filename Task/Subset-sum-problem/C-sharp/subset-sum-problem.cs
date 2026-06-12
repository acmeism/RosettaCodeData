using System;
using System.Collections.Generic;

namespace SubsetSum {
    class Item {
        public Item(string word, int weight) {
            Word = word;
            Weight = weight;
        }

        public string Word { get; set; }
        public int Weight { get; set; }

        public override string ToString() {
            return string.Format("({0}, {1})", Word, Weight);
        }
    }

    class Program {
        private static readonly List<Item> items = new List<Item>() {
            new Item("alliance", -624),
            new Item("archbishop", -915),
            new Item("balm", 397),
            new Item("bonnet", 452),
            new Item("brute", 870),
            new Item("centipede", -658),
            new Item("cobol", 362),
            new Item("covariate", 590),
            new Item("departure", 952),
            new Item("deploy", 44),
            new Item("diophantine", 645),
            new Item("efferent", 54),
            new Item("elysee", -326),
            new Item("eradicate", 376),
            new Item("escritoire", 856),
            new Item("exorcism", -983),
            new Item("fiat", 170),
            new Item("filmy", -874),
            new Item("flatworm", 503),
            new Item("gestapo", 915),
            new Item("infra", -847),
            new Item("isis", -982),
            new Item("lindholm", 999),
            new Item("markham", 475),
            new Item("mincemeat", -880),
            new Item("moresby", 756),
            new Item("mycenae", 183),
            new Item("plugging", -266),
            new Item("smokescreen", 423),
            new Item("speakeasy", -745),
            new Item("vein", 813),
        };

        private static readonly int n = items.Count;
        private static readonly int LIMIT = 5;

        private static int[] indices = new int[n];
        private static int count = 0;

        private static void ZeroSum(int i, int w) {
            if (i != 0 && w == 0) {
                for (int j = 0; j < i; j++) {
                    Console.Write("{0} ", items[indices[j]]);
                }
                Console.WriteLine("\n");
                if (count < LIMIT) count++;
                else return;
            }
            int k = (i != 0) ? indices[i - 1] + 1 : 0;
            for (int j = k; j < n; j++) {
                indices[i] = j;
                ZeroSum(i + 1, w + items[j].Weight);
                if (count == LIMIT) return;
            }
        }

        static void Main(string[] args) {
            Console.WriteLine("The weights of the following {0} subsets add up to zero:\n", LIMIT);
            ZeroSum(0, 0);
        }
    }
}
