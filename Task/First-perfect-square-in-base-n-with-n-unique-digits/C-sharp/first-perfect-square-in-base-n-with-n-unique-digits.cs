using System;
using System.Collections.Generic;
using System.Numerics;

static class Program
{
    static byte Base, bmo, blim, ic; static DateTime st0; static BigInteger bllim, threshold;
    static HashSet<byte> hs = new HashSet<byte>(), o = new HashSet<byte>();
    static string chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|";
    static List<BigInteger> limits;
    static string ms;

    // convert BigInteger to string using current base
    static string toStr(BigInteger b) {
        string res = ""; BigInteger re; while (b > 0) {
            b = BigInteger.DivRem(b, Base, out re); res = chars[(byte)re] + res;
        } return res;
    }

    // check for a portion of digits, bailing if uneven
    static bool allInQS(BigInteger b) {
        BigInteger re; int c = ic; hs.Clear(); hs.UnionWith(o); while (b > bllim) {
            b = BigInteger.DivRem(b, Base, out re);
            hs.Add((byte)re); c += 1; if (c > hs.Count) return false;
        } return true;
    }

    // check for a portion of digits, all the way to the end
    static bool allInS(BigInteger b) {
        BigInteger re; hs.Clear(); hs.UnionWith(o); while (b > bllim) {
            b = BigInteger.DivRem(b, Base, out re); hs.Add((byte)re);
        } return hs.Count == Base;
    }

    // check for all digits, bailing if uneven
    static bool allInQ(BigInteger b) {
        BigInteger re; int c = 0; hs.Clear(); while (b > 0) {
            b = BigInteger.DivRem(b, Base, out re);
            hs.Add((byte)re); c += 1; if (c > hs.Count) return false;
        } return true;
    }

    // check for all digits, all the way to the end
    static bool allIn(BigInteger b) {
        BigInteger re; hs.Clear(); while (b > 0) {
            b = BigInteger.DivRem(b, Base, out re); hs.Add((byte)re);
        } return hs.Count == Base;
    }

    // parse a string into a BigInteger, using current base
    static BigInteger to10(string s) {
        BigInteger res = 0; foreach (char i in s) res = res * Base + chars.IndexOf(i);
        return res;
    }

    // returns the minimum value string, optionally inserting extra digit
    static string fixup(int n) {
        string res = chars.Substring(0, Base); if (n > 0) res = res.Insert(n, n.ToString());
        return "10" + res.Substring(2);
    }

    // checks the square against the threshold, advances various limits when needed
    static void check(BigInteger sq) {
        if (sq > threshold) {
            o.Remove((byte)chars.IndexOf(ms[blim])); blim -= 1; ic -= 1;
            threshold = limits[bmo - blim - 1]; bllim = to10(ms.Substring(0, blim + 1));
        }
    }

    // performs all the caclulations for the current base
    static void doOne() {
        limits = new List<BigInteger>();
        bmo = (byte)(Base - 1); byte dr = 0; if ((Base & 1) == 1) dr = (byte)(Base >> 1);
        o.Clear(); blim = 0;
        byte id = 0; int inc = 1; long i = 0; DateTime st = DateTime.Now; if (Base == 2) st0 = st;
        byte[] sdr = new byte[bmo]; byte rc = 0; for (i = 0; i < bmo; i++) {
            sdr[i] = (byte)((i * i) % bmo); rc += sdr[i] == dr ? (byte)1 : (byte)0;
            sdr[i] += sdr[i] == 0 ? bmo : (byte)0;
        } i = 0; if (dr > 0) {
            id = Base;
            for (i = 1; i <= dr; i++) if (sdr[i] >= dr) if (id > sdr[i]) id = sdr[i]; id -= dr;
            i = 0;
        } ms = fixup(id);
        BigInteger sq = to10(ms); BigInteger rt = new BigInteger(Math.Sqrt((double)sq) + 1);
        sq = rt * rt; if (Base > 9) {
            for (int j = 1; j < Base; j++)
                limits.Add(to10(ms.Substring(0, j) + new string(chars[bmo], Base - j + (rc > 0 ? 0 : 1))));
            limits.Reverse(); while (sq < limits[0]) { rt++; sq = rt * rt; }
        }
        BigInteger dn = (rt << 1) + 1; BigInteger d = 1; if (Base > 3 && rc > 0) {
            while (sq % bmo != dr) { rt += 1; sq += dn; dn += 2; } // alligns sq to dr
            inc = bmo / rc;
            if (inc > 1) { dn += rt * (inc - 2) - 1; d = inc * inc; }
            dn += dn + d;
        }
        d <<= 1; if (Base > 9) {
            blim = 0; while (sq < limits[bmo - blim - 1]) blim++; ic = (byte)(blim + 1);
            threshold = limits[bmo - blim - 1];
            if (blim > 0) for (byte j = 0; j <= blim; j++) o.Add((byte)chars.IndexOf(ms[j]));
            if (blim > 0) bllim = to10(ms.Substring(0, blim + 1)); else bllim = 0;
            if (Base > 5 && rc > 0)
                do { if (allInQS(sq)) break; sq += dn; dn += d; i += 1; check(sq); } while (true);
            else
                do { if (allInS(sq)) break; sq += dn; dn += d; i += 1; check(sq); } while (true);
        } else {
            if (Base > 5 && rc > 0)
                do { if (allInQ(sq)) break; sq += dn; dn += d; i += 1; } while (true);
            else
                do { if (allIn(sq)) break; sq += dn; dn += d; i += 1; } while (true);
        } rt += i * inc;
        Console.WriteLine("{0,3}  {1,2}  {2,2} {3,20} -> {4,-40} {5,10} {6,9:0.0000}s  {7,9:0.0000}s",
            Base, inc, (id > 0 ? chars.Substring(id, 1) : " "), toStr(rt), toStr(sq), i,
            (DateTime.Now - st).TotalSeconds, (DateTime.Now - st0).TotalSeconds);
    }

    static void Main(string[] args) {
        Console.WriteLine("base inc id                 root    square" +
            "                                   test count    time        total");
        for (Base = 2; Base <= 28; Base++) doOne();
        Console.WriteLine("Elasped time was {0,8:0.00} minutes", (DateTime.Now - st0).TotalMinutes);
    }
}
