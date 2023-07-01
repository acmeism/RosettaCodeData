using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.Serialization;

public static class MergeAndAggregateDatasets
{
    public static void Main()
    {
        string patientsCsv = @"
PATIENT_ID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz";

        string visitsCsv = @"
PATIENT_ID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3";

        string format = "yyyy-MM-dd";
        var formatProvider = new DateTimeFormat(format).FormatProvider;

        var patients = ParseCsv(
            patientsCsv.Split(Environment.NewLine, StringSplitOptions.RemoveEmptyEntries),
            line => (PatientId: int.Parse(line[0]), LastName: line[1]));

        var visits = ParseCsv(
            visitsCsv.Split(Environment.NewLine, StringSplitOptions.RemoveEmptyEntries),
            line => (
                PatientId: int.Parse(line[0]),
                VisitDate: DateTime.TryParse(line[1], formatProvider, DateTimeStyles.None, out var date) ? date : default(DateTime?),
                Score: double.TryParse(line[2], out double score) ? score : default(double?)
            )
        );

        var results =
            patients.GroupJoin(visits,
                p => p.PatientId,
                v => v.PatientId,
                (p, vs) => (
                    p.PatientId,
                    p.LastName,
                    LastVisit: vs.Max(v => v.VisitDate),
                    ScoreSum: vs.Sum(v => v.Score),
                    ScoreAvg: vs.Average(v => v.Score)
                )
            ).OrderBy(r => r.PatientId);

        Console.WriteLine("| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |");
        foreach (var r in results) {
            Console.WriteLine($"| {r.PatientId,-10} | {r.LastName,-8} | {r.LastVisit?.ToString(format) ?? "",-10} | {r.ScoreSum,9} | {r.ScoreAvg,9} |");
        }
    }

    private static IEnumerable<T> ParseCsv<T>(string[] contents, Func<string[], T> constructor)
    {
        for (int i = 1; i < contents.Length; i++) {
            var line = contents[i].Split(',');
            yield return constructor(line);
        }
    }

}
