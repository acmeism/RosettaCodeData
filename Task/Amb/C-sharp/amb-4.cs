using System.Linq;
using static System.Console;

namespace Amb {
    class Program {
        static void Main(string[] args) {

            var amb = new Amb();

            var set1 = amb.Choose("the", "that", "a");
            var set2 = amb.Choose("frog", "elephant", "thing");
            amb.Require(() => set1.Value.Last() == set2.Value[0]);
            var set3 = amb.Choose("walked", "treaded", "grows");
            amb.Require(() => set2.Value.Last() == set3.Value[0]);
            var set4 = amb.Choose("slowly", "quickly");
            amb.Require(() => set3.Value.Last() == set4.Value[0]);

            WriteLine(amb.Disambiguate()? $"{set1} {set2} {set3} {set4}" : "Amb failed");
            Read();

            // problem from http://www.randomhacks.net/articles/2005/10/11/amb-operator
            amb = new Amb();

            var x = amb.Choose(1, 2, 3);
            var y = amb.Choose(4, 5, 6);
            amb.Require(() => x.Value * y.Value == 8);

            WriteLine(amb.Disambiguate() ? $"{x} * {y} = 8" : "Amb failed");
            Read();
        }
    }
}
