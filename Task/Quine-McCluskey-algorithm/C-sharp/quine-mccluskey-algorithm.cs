using System;
using System.Collections.Generic;
using System.Text;

class QuineMcCluskey
{
    public static string B2s(int i, int vars)
    {
        StringBuilder s = new StringBuilder();
        for (int k = 0; k < vars; k++)
        {
            s.Insert(0, ((i & 1) == 1 ? "1" : "0"));
            i >>= 1;
        }
        return s.ToString();
    }

    public static int BitCount(string s)
    {
        int count = 0;
        for (int i = 0; i < s.Length; i++)
        {
            if (s[i] == '1') count++;
        }
        return count;
    }

    public static string Merge(string i, string j)
    {
        int len = Math.Min(i.Length, j.Length);
        int difCnt = 0;
        StringBuilder s = new StringBuilder();
        for (int k = 0; k < len; k++)
        {
            char a = i[k], b = j[k];
            if (a == 'X' || b == 'X')
            {
                if (a != b)
                {
                    return "";
                }
                s.Append(a);
            }
            else if (a != b)
            {
                difCnt++;
                if (difCnt > 1)
                {
                    return "";
                }
                s.Append('X');
            }
            else
            {
                s.Append(a);
            }
        }
        return s.ToString();
    }

    public static void AddToSet(SetType s, string item)
    {
        foreach (string str in s.Items)
        {
            if (str.Equals(item))
            {
                return;
            }
        }
        s.Items.Add(item);
    }

    public static bool InSet(SetType s, string item)
    {
        foreach (string str in s.Items)
        {
            if (str.Equals(item))
            {
                return true;
            }
        }
        return false;
    }

    public static void UnionSets(SetType dest, SetType src)
    {
        foreach (string item in src.Items)
        {
            AddToSet(dest, item);
        }
    }

    public static void ComputePrimes(SetType cubes, int vars, SetType primes)
    {
        SetType[] sigma = new SetType[vars + 1];
        for (int i = 0; i <= vars; i++)
        {
            sigma[i] = new SetType();
        }
        int sigmaCount = 0;

        for (int j = 0; j <= vars; j++)
        {
            foreach (string cube in cubes.Items)
            {
                if (BitCount(cube) == j)
                {
                    AddToSet(sigma[j], cube);
                }
            }
            if (sigma[j].Items.Count > 0)
            {
                sigmaCount = j + 1;
            }
        }

        primes.Items.Clear();

        while (sigmaCount > 0)
        {
            SetType[] nsigma = new SetType[sigmaCount - 1];
            for (int i = 0; i < sigmaCount - 1; i++)
            {
                nsigma[i] = new SetType();
            }
            SetType redundant = new SetType();

            for (int i = 0; i < sigmaCount - 1; i++)
            {
                SetType c1 = sigma[i];
                SetType c2 = sigma[i + 1];
                SetType nc = new SetType();

                foreach (string a in c1.Items)
                {
                    foreach (string b in c2.Items)
                    {
                        string m = Merge(a, b);
                        if (!m.Equals(""))
                        {
                            AddToSet(nc, m);
                            AddToSet(redundant, a);
                            AddToSet(redundant, b);
                        }
                    }
                }
                nsigma[i] = nc;
            }

            for (int i = 0; i < sigmaCount; i++)
            {
                foreach (string cube in sigma[i].Items)
                {
                    if (!InSet(redundant, cube))
                    {
                        AddToSet(primes, cube);
                    }
                }
            }

            sigmaCount = nsigma.Length;
            if (sigmaCount > 0)
            {
                for (int i = 0; i < sigmaCount; i++)
                {
                    sigma[i] = nsigma[i];
                }
            }
        }
    }

    public static void ActivePrimes(int cubesel, SetType primes, SetType result)
    {
        result.Items.Clear();
        string s = B2s(cubesel, primes.Items.Count);
        for (int i = 0; i < primes.Items.Count; i++)
        {
            if (s[i] == '1')
            {
                AddToSet(result, primes.Items[i]);
            }
        }
    }

    public static bool IsCover(string prime, string one)
    {
        int len = Math.Min(prime.Length, one.Length);
        for (int i = 0; i < len; i++)
        {
            char p = prime[i], o = one[i];
            if (p != 'X' && p != o)
            {
                return false;
            }
        }
        return true;
    }

    public static bool IsFullCover(SetType allPrimes, SetType ones)
    {
        foreach (string one in ones.Items)
        {
            bool covered = false;
            foreach (string prime in allPrimes.Items)
            {
                if (IsCover(prime, one))
                {
                    covered = true;
                    break;
                }
            }
            if (!covered)
            {
                return false;
            }
        }
        return true;
    }

    public static void UnateCover(SetType primes, SetType ones, SetType result)
    {
        int minCount = 1000;
        int minSel = -1;
        SetType active = new SetType();

        int total = (1 << primes.Items.Count);
        for (int cubesel = 0; cubesel < total; cubesel++)
        {
            ActivePrimes(cubesel, primes, active);
            if (IsFullCover(active, ones))
            {
                int cnt = 0;
                string binRep = B2s(cubesel, primes.Items.Count);
                for (int i = 0; i < binRep.Length; i++)
                {
                    if (binRep[i] == '1') cnt++;
                }
                if (cnt < minCount)
                {
                    minCount = cnt;
                    minSel = cubesel;
                }
            }
        }

        if (minSel != -1)
        {
            ActivePrimes(minSel, primes, result);
        }
        else
        {
            result.Items.Clear();
        }
    }

    public static SetType Qm(int[] ones, int[] zeros, int[] dc)
    {
        SetType result = new SetType();

        if (ones.Length == 0 && zeros.Length == 0 && dc.Length == 0)
        {
            return result;
        }

        int maxVal = 0;
        foreach (int val in ones) if (val > maxVal) maxVal = val;
        foreach (int val in zeros) if (val > maxVal) maxVal = val;
        foreach (int val in dc) if (val > maxVal) maxVal = val;

        int numvars = 0;
        if (maxVal == 0)
        {
            numvars = 1;
        }
        else
        {
            int tmp = maxVal;
            while (tmp > 0)
            {
                numvars++;
                tmp >>= 1;
            }
        }

        SetType onesSet = new SetType();
        SetType zerosSet = new SetType();
        SetType dcSet = new SetType();

        foreach (int val in ones)
        {
            AddToSet(onesSet, B2s(val, numvars));
        }
        foreach (int val in zeros)
        {
            AddToSet(zerosSet, B2s(val, numvars));
        }
        foreach (int val in dc)
        {
            AddToSet(dcSet, B2s(val, numvars));
        }

        SetType cubes = new SetType();
        UnionSets(cubes, onesSet);
        UnionSets(cubes, dcSet);

        SetType primes = new SetType();
        ComputePrimes(cubes, numvars, primes);

        UnateCover(primes, onesSet, result);
        return result;
    }

    public static void Main(string[] args)
    {
        int[] ones = { 1, 2, 5 };
        int[] zeros = { };
        int[] dc = { 0, 7 };

        SetType result = Qm(ones, zeros, dc);

        StringBuilder output = new StringBuilder();
        foreach (string item in result.Items)
        {
            if (output.Length > 0)
            {
                output.Append(" ");
            }
            output.Append(item);
        }
        Console.WriteLine(output.ToString());
    }
}

class SetType
{
    public List<string> Items;

    public SetType()
    {
        this.Items = new List<string>();
    }
}
