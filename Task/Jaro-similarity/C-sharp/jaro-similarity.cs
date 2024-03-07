using System;

public class JaroDistance {
    public static double Jaro(string s, string t) {
        int s_len = s.Length;
        int t_len = t.Length;

        if (s_len == 0 && t_len == 0) return 1;

        int match_distance = Math.Max(s_len, t_len) / 2 - 1;

        bool[] s_matches = new bool[s_len];
        bool[] t_matches = new bool[t_len];

        int matches = 0;
        int transpositions = 0;

        for (int i = 0; i < s_len; i++) {
            int start = Math.Max(0, i - match_distance);
            int end = Math.Min(i + match_distance + 1, t_len);

            for (int j = start; j < end; j++) {
                if (t_matches[j]) continue;
                if (s[i] != t[j]) continue;
                s_matches[i] = true;
                t_matches[j] = true;
                matches++;
                break;
            }
        }

        if (matches == 0) return 0;

        int k = 0;
        for (int i = 0; i < s_len; i++) {
            if (!s_matches[i]) continue;
            while (!t_matches[k]) k++;
            if (s[i] != t[k]) transpositions++;
            k++;
        }

        return (((double)matches / s_len) +
                ((double)matches / t_len) +
                (((double)matches - transpositions / 2.0) / matches)) / 3.0;
    }

    public static void Main(string[] args) {
        Console.WriteLine(Jaro("MARTHA", "MARHTA"));
        Console.WriteLine(Jaro("DIXON", "DICKSONX"));
        Console.WriteLine(Jaro("JELLYFISH", "SMELLYFISH"));
    }
}
