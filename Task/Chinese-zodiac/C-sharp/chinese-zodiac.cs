using System;

namespace ChineseZodiac {
    class Program {
        static string[] animals = { "Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig" };
        static string[] elements = { "Wood", "Fire", "Earth", "Metal", "Water" };
        static string[] animalChars = { "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥" };
        static string[,] elementChars = { { "甲", "丙", "戊", "庚", "壬" }, { "乙", "丁", "己", "辛", "癸" } };

        static string getYY(int year) {
            if (year % 2 == 0) {
                return "yang";
            }
            return "yin";
        }

        static void Main(string[] args) {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            int[] years = { 1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017 };
            for (int i = 0; i < years.Length; i++) {
                int ei = (int)Math.Floor((years[i] - 4.0) % 10 / 2);
                int ai = (years[i] - 4) % 12;
                Console.WriteLine("{0} is the year of the {1} {2} ({3}). {4}{5}", years[i], elements[ei], animals[ai], getYY(years[i]), elementChars[years[i] % 2, ei], animalChars[(years[i] - 4) % 12]);
            }
        }
    }
}
