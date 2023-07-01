using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CalendarStuff
{

    class Program
    {
        static void Main(string[] args)
        {
            Console.WindowHeight = 46;
            Console.Write(buildMonths(new DateTime(1969, 1, 1)));
            Console.Read();
        }
        private static string buildMonths(DateTime date)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(center("[Snoop]", 24 * 3));
            sb.AppendLine();
            sb.AppendLine(center(date.Year.ToString(), 24 * 3));

            List<DateTime> dts = new List<DateTime>();
            while (true)
            {
                dts.Add(date);
                if (date.Year != ((date = date.AddMonths(1)).Year))
                {
                    break;
                }
            }
            var jd = dts.Select(a => buildMonth(a).GetEnumerator()).ToArray();

            int sCur=0;
            while (sCur<dts.Count)
            {
                sb.AppendLine();
                int curMonth=0;
                var j = jd.Where(a => curMonth++ >= sCur && curMonth - 1 < sCur + 3).ToArray(); //grab the next 3
                sCur += j.Length;
                bool breakOut = false;
                while (!breakOut)
                {
                    int inj = 1;
                    foreach (var cd in j)
                    {
                        if (cd.MoveNext())
                        {
                            sb.Append((cd.Current.Length == 21 ? cd.Current : cd.Current.PadRight(21, ' ')) + "     ");
                        }
                        else
                        {
                            sb.Append("".PadRight(21, ' ') + "     ");
                            breakOut = true;
                        }
                        if (inj++ % 3 == 0) sb.AppendLine();
                    }
                }

            }
            return sb.ToString();
        }


        private static IEnumerable<string> buildMonth(DateTime date)
        {
            yield return center(date.ToString("MMMM"),7*3);
            var j = DateTime.DaysInMonth(date.Year, date.Month);
            yield return Enum.GetNames(typeof(DayOfWeek)).Aggregate("", (current, result) => current + (result.Substring(0, 2).ToUpper() + " "));
            string cur = "";
            int total = 0;

            foreach (var day in Enumerable.Range(-((int)date.DayOfWeek),j + (int)date.DayOfWeek))
            {
                cur += (day < 0 ? "  " : ((day < 9 ? " " : "") + (day + 1))) +" ";
                if (total++ > 0 && (total ) % 7 == 0)
                {
                    yield return cur;
                    cur = "";
                }
            }
            yield return cur;
        }
        private static string center(string s, int len)
        {
            return (s.PadLeft((len - s.Length) / 2 + s.Length, ' ').PadRight((len), ' '));
        }
    }
}
