using System;
using System.Collections.Generic;
using System.Linq;

namespace cppfpe
{
    class Program
    {
        static int n, ns;               // rank, rank squared
        static long[] AnyR;             // Any Rotation count
        static long[] nFlip;            // Non-Flipped count
        static long[] Frees;            // Free Polyominoes count
        static int[] fChk, fCkR;        // field checks
        static int fSiz, fWid;          // field size, width
        static int[] dirs;              // directions
        static int[] rotO, rotX, rotY;  // rotations
        static List<string> polys;      // results
        static int target;              // rank to display
        static int clipAt;              // max columns for display

        static int Main(string[] args)
        {
            polys = new List<string>();
            n = 11; if (!(args.Length == 0)) int.TryParse(args[0], out n);
            if (n < 1 || n > 24) return 1;
            target = 5;
            Console.WriteLine("Counting polyominoes to rank {0}...", n);
            clipAt = 120;
            DateTime start = DateTime.Now;
            CountEm();
            TimeSpan ti = DateTime.Now - start;
            if (polys.Count > 0)
            {
                Console.WriteLine("Displaying rank {0}:", target);
                Console.WriteLine(Assemble(polys));
            }
            Console.WriteLine("Displaying results:");
            Console.WriteLine(" n      All Rotations     Non-Flipped      Free Polys");
            for (int i = 1; i <= n; i++)
                Console.WriteLine("{0,2} :{1,17}{2,16}{3,16}", i, AnyR[i], nFlip[i], Frees[i]);
            Console.WriteLine(string.Format("Elasped: {0,2}d {1,2}h {2,2}m {3:00}s {4:000}ms",
                              ti.Days, ti.Hours, ti.Minutes, ti.Seconds, ti.Milliseconds).Replace("  0d ", "")
                              .Replace(" 0h", "").Replace(" 0m", "").Replace(" 00s", ""));
            long ms = (long)ti.TotalMilliseconds, lim = int.MaxValue >> 2;
            if (ms > 250)
            {
                Console.WriteLine("Estimated completion times:");
                for (int i = n + 1; i <= n + 10; i++)
                {
                    if (ms >= lim) break; ms += 44; ms <<= 2; ti = TimeSpan.FromMilliseconds(ms);
                    Console.WriteLine("{0,2} : {1,2}d {2,2}h {3,2}m {4:00}.{5:000}s", i,
                        ti.Days, ti.Hours, ti.Minutes, ti.Seconds, ti.Milliseconds);
                }
            }
            if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
            return 0;
        }

        static void CountEm()
        {
            ns = n * n;
            AnyR = new long[n + 1];
            nFlip = new long[n + 1];
            Frees = new long[n + 1];
            fWid = n * 2 - 2;
            fSiz = (n - 1) * (n - 1) * 2 + 1;
            int[] pnField = new int[fSiz];
            int[] pnPutList = new int[fSiz];
            fChk = new int[ns];
            fCkR = new int[ns];
            dirs = new int[] { 1, fWid, -1, -fWid };
            rotO = new int[] { 0, n - 1, ns - 1, ns - n, n - 1, 0, ns - n, ns - 1 };
            rotX = new int[] { 1, n, -1, -n, -1, n, 1, -n };
            rotY = new int[] { n, -1, -n, 1, n, 1, -n, -1 };
            Recurse(0, pnField, pnPutList, 0, 1);
        }

        static void Recurse(int lv, int[] field, int[] putlist, int putno, int putlast)
        {
            CheckIt(field, lv);
            if (n == lv) return;
            int pos;
            for (int i = putno; i < putlast; i++)
            {
                field[pos = putlist[i]] |= 1;
                int k = 0;
                foreach (int dir in dirs)
                {
                    int pos2 = pos + dir;
                    if (0 <= pos2 && pos2 < fSiz && (field[pos2] == 0))
                    {
                        field[pos2] = 2;
                        putlist[putlast + k++] = pos2;
                    }
                }
                Recurse(lv + 1, field, putlist, i + 1, putlast + k);
                for (int j = 0; j < k; j++) field[putlist[putlast + j]] = 0;
                field[pos] = 2;
            }
            for (int i = putno; i < putlast; i++) field[putlist[i]] &= -2;
        }

        static void CheckIt(int[] field, int lv)
        {
            AnyR[lv]++;
            for (int i = 0; i < ns; i++) fChk[i] = 0;
            int x, y;
            for (x = n; x < fWid; x++)
                for (y = 0; y + x < fSiz; y += fWid)
                    if ((field[x + y] & 1) == 1) goto bail;
            bail:
            int x2 = n - x, t;
            for (int i = 0; i < fSiz; i++)
                if ((field[i] & 1) == 1) fChk[((t = (i + n - 2)) % fWid) + x2 + (t / fWid * n)] = 1;
            int of1; for (of1 = 0; of1 < fChk.Length && (fChk[of1] == 0); of1++) ;
            bool c = true; int r;
            for (r = 1; r < 8 && c; r++)
            {
                for (x = 0; x < n; x++) for (y = 0; y < n; y++)
                        fCkR[rotO[r] + rotX[r] * x + rotY[r] * y] = fChk[x + y * n];
                int of2; for (of2 = 0; of2 < fCkR.Length && (fCkR[of2] == 0); of2++) ;
                of2 -= of1;
                for (int i = of1; i < ns - ((of2 > 0) ? of2 : 0); i++)
                {
                    if (fChk[i] > fCkR[i + of2]) break;
                    if (fChk[i] < fCkR[i + of2]) { c = false; break; }
                }
            }
            if (r > 4) nFlip[lv]++;
            if (c)
            {
                if (lv == target) polys.Add(toStr(field.ToArray()));
                Frees[lv]++;
            }
        }

        static string toStr(int[] field) // converts field into a minimal string
        {
            char [] res = new string(' ', n * (fWid + 1) - 1).ToCharArray();
            for (int i = fWid; i < res.Length; i += fWid+1) res[i] = '\n';
            for (int i = 0, j = n - 2; i < field.Length; i++, j++)
            {
                if ((field[i] & 1) == 1) res[j] = '#';
                if (j % (fWid + 1) == fWid) i--;
            }
            List<string> t = new string(res).Split('\n').ToList();
            int nn = 100, m = 0, v, k = 0; // trim down
            foreach (string s in t)
            {
                if ((v = s.IndexOf('#')) < nn) if (v >= 0) nn = v;
                if ((v = s.LastIndexOf('#')) > m) if (v < fWid +1) m = v;
                if (v < 0) break; k++;
            }
            m = m - nn + 1; // convert difference to length
            for (int i = t.Count - 1; i >= 0; i--)
            {
                if (i >= k) t.RemoveAt(i);
                else t[i] = t[i].Substring(nn, m);
            }
            return String.Join("\n", t.ToArray());
        }

        // assembles string representation of polyominoes into larger horizontal band
        static string Assemble(List<string> p)
        {
            List<string> lines = new List<string>();
            for (int i = 0; i < target; i++) lines.Add(string.Empty);
            foreach (string poly in p)
            {
                List<string> t = poly.Split('\n').ToList();
                if (t.Count < t[0].Length) t = flipXY(t);
                for (int i = 0; i < lines.Count; i++)
                    lines[i] += (i < t.Count) ? ' ' + t[i] + ' ': new string(' ', t[0].Length + 2);
            }
            for (int i = lines.Count - 1; i > 0; i--)
                if (lines[i].IndexOf('#') < 0) lines.RemoveAt(i);
            if (lines[0].Length >= clipAt / 2-2) Wrap(lines, clipAt / 2-2);
            lines = Cornered(string.Join("\n", lines.ToArray())).Split('\n').ToList();
            return String.Join("\n", lines.ToArray());
        }

        static List<string> flipXY(List<string> p)  // flips a small string
        {
            List<string> res = new List<string>();
            for (int i = 0; i < p[0].Length; i++) res.Add(string.Empty);
            for (int i = 0; i < res.Count; i++)
                for(int j = 0; j < p.Count; j++) res[i] += p[j][i];
            return res;
        }

        static string DW(string s)  // double widths a string
        {
            string t = string.Empty;
            foreach (char c in s) t += string.Format("{0}{0}",c);
            return t;
        }

        static void Wrap(List<string> s, int w) // wraps a wide List<string>
        {
            int last = 0;
            while (s.Last().Length >= w)
            {
                int x = w, lim = s.Count; bool ok;
                do
                {
                    ok = true;
                    for (int i = last; i < lim; i++)
                        if (s[i][x] != ' ')
                        { ok = false; x--; break; }
                } while (!ok);
                for (int i = last; i < lim; i++)
                    if (s[i].Length > x) { s.Add(s[i].Substring(x)); s[i] = s[i].Substring(0, x + 1); }
                last = lim;
            }
            last = 0;
            for (int i = s.Count - 1; i > 0; i--)
                if ((last = (s[i].IndexOf('#') < 0) ? last + 1 : 0) > 1) s.RemoveAt(i + 1);
        }

        static string Cornered(string s)    // converts plain ascii art into cornered version
        {
            string[] lines = s.Split('\n');
            string res = string.Empty;
            string line = DW(new string(' ', lines[0].Length)), last;
            for (int i = 0; i < lines.Length; i++)
            {
                last = line; line = DW(lines[i]);
                res += Puzzle(last, line) + '\n';
            }
            res += Puzzle(line, DW(new string(' ', lines.Last().Length))) + '\n';
            return res;
        }

        static string Puzzle(string a, string b)    // tests each intersection to determine correct corner symbol
        {
            string res = string.Empty;
            if (a.Length > b.Length) b += new string(' ', a.Length - b.Length);
            if (a.Length < b.Length) a += new string(' ', b.Length - a.Length);
            for (int i = 0; i < a.Length - 1; i++)
                res += " 12└4┘─┴8│┌├┐┤┬┼"[(a[i] == a[i + 1] ? 0 : 1) +
                                          (b[i + 1] == a[i + 1] ? 0 : 2) +
                                          (a[i] == b[i] ? 0 : 4) +
                                          (b[i] == b[i + 1] ? 0 : 8)];
            return res;
        }
    }
}
