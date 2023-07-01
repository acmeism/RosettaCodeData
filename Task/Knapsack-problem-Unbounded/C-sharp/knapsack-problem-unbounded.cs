/*Knapsack

  This model finds the integer optimal packing of a knapsack

  Nigel_Galloway
  January 29th., 2012
*/
using Microsoft.SolverFoundation.Services;

namespace KnapU
{
    class Item {
        public string Name {get; set;}
        public int Value {get; set;}
        public double Weight {get; set;}
        public double Volume {get; set;}

        public Item(string name, int value, double weight, double volume) {
            Name = name;
            Value = value;
            Weight = weight;
            Volume = volume;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            SolverContext context = SolverContext.GetContext();
            Model model = context.CreateModel();
            Item[] Knapsack = new Item[] {
                new Item("Panacea", 3000, 0.3, 0.025),
                new Item("Ichor", 1800, 0.2, 0.015),
                new Item("Gold", 2500, 2.0, 0.002)
            };
            Set items = new Set(Domain.Any, "items");
            Decision take = new Decision(Domain.IntegerNonnegative, "take", items);
            model.AddDecision(take);
            Parameter value = new Parameter(Domain.IntegerNonnegative, "value", items);
            value.SetBinding(Knapsack, "Value", "Name");
            Parameter weight = new Parameter(Domain.RealNonnegative, "weight", items);
            weight.SetBinding(Knapsack, "Weight", "Name");
            Parameter volume = new Parameter(Domain.RealNonnegative, "volume", items);
            volume.SetBinding(Knapsack, "Volume", "Name");
            model.AddParameters(value, weight, volume);
            model.AddConstraint("knap_weight", Model.Sum(Model.ForEach(items, t => take[t] * weight[t])) <= 25);
            model.AddConstraint("knap_vol", Model.Sum(Model.ForEach(items, t => take[t] * volume[t])) <= 0.25);
            model.AddGoal("knap_value", GoalKind.Maximize, Model.Sum(Model.ForEach(items, t => take[t] * value[t])));
            Solution solution = context.Solve(new SimplexDirective());
            Report report = solution.GetReport();
            System.Console.Write("{0}", report);
        }
    }
}
