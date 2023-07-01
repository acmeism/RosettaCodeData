using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SolverFoundation.Solvers;

using static System.Console;

static class ZebraProgram
{
    static ConstraintSystem _solver;

    static CspTerm IsLeftOf(this CspTerm left, CspTerm right) => _solver.Equal(1, right - left);
    static CspTerm IsInSameHouseAs(this CspTerm left, CspTerm right) => _solver.Equal(left, right);
    static CspTerm IsNextTo(this CspTerm left, CspTerm right) => _solver.Equal(1,_solver.Abs(left-right));
    static CspTerm IsInHouse(this CspTerm @this, int i) => _solver.Equal(i, @this);

    static (ConstraintSystem, Dictionary<CspTerm, string>) BuildSolver()
    {
        var solver = ConstraintSystem.CreateSolver();
        _solver = solver;
        var terms = new Dictionary<CspTerm, string>();

        CspTerm Term(string name)
        {
            CspTerm x = solver.CreateVariable(solver.CreateIntegerInterval(1, 5), name);
            terms.Add(x, name);
            return x;
        };

        CspTerm red = Term("red"), green = Term("green"), white = Term("white"), blue = Term("blue"), yellow = Term("yellow");
        CspTerm tea = Term("tea"), coffee = Term("coffee"), milk = Term("milk"), beer = Term("beer"), water = Term("water");
        CspTerm english = Term("Englishman"), swede = Term("Swede"), dane = Term("Dane"), norwegian = Term("Norwegian"),
            german = Term("German");
        CspTerm dog = Term("dog"), birds = Term("birds"), cats = Term("cats"), horse = Term("horse"), zebra = Term("zebra");
        CspTerm pallmall = Term("pallmall"), dunhill = Term("dunhill"), blend = Term("blend"), bluemaster = Term("bluemaster"),
            prince = Term("prince");

        solver.AddConstraints(
            solver.Unequal(english, swede, german, dane, norwegian),
            solver.Unequal(red, green, white, blue, yellow),
            solver.Unequal(dog, cats, birds, horse, zebra),
            solver.Unequal(pallmall, dunhill, bluemaster, prince, blend),
            solver.Unequal(tea, coffee, milk, beer, water),

            english.IsInSameHouseAs(red), //r2
            swede.IsInSameHouseAs(dog), //r3
            dane.IsInSameHouseAs(tea), //r4
            green.IsLeftOf(white), //r5
            green.IsInSameHouseAs(coffee), //r6
            pallmall.IsInSameHouseAs(birds), //r7
            dunhill.IsInSameHouseAs(yellow), //r8
            milk.IsInHouse(3), //r9
            norwegian.IsInHouse(1), //r10
            blend.IsNextTo(cats), //r11
            horse.IsNextTo(dunhill),// r12
            bluemaster.IsInSameHouseAs(beer), // r13
            german.IsInSameHouseAs(prince), // r14
            norwegian.IsNextTo(blue), //r15
            water.IsNextTo(blend) //r16
        );
        return (solver, terms);
    }

    static List<string>[] TermsToString(ConstraintSolverSolution solved, Dictionary<CspTerm, string> terms)
    {
        var h = new List<string>[5];
        for (int i = 0; i < 5; i++)
            h[i] = new List<string>();

        foreach (var (key, value) in terms.Select(kvp => (kvp.Key, kvp.Value)))
        {
            if (!solved.TryGetValue(key, out object house))
                throw new InvalidProgramException("Can't find a term - {value} - in the solution");
            h[(int)house - 1].Add(value);
        }

        return h;
    }

    static new string ToString(List<string>[] houses)
    {
        var sb = new StringBuilder();
        foreach (var house in houses)
        {
            sb.Append("|");
            foreach (var attrib in house)
                sb.Append($"{attrib,-10}|");
            sb.Append("\n");
        }
        return sb.ToString();
    }

    public static void Main()
    {
        var (solver, terms) = BuildSolver();

        var solved = solver.Solve();

        if (solved.HasFoundSolution)
        {
            var h = TermsToString(solved, terms);

            var owner = String.Concat(h.Where(l => l.Contains("zebra")).Select(l => l[2]));
            WriteLine($"The {owner} owns the zebra");
            WriteLine();
            Write(ToString(h));
        }
        else
            WriteLine("No solution found.");
        Read();
    }
}
