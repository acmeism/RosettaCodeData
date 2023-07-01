namespace Algorithms
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class TopologicalSorter<ValueType>
    {
        private class Relations
        {
            public int Dependencies = 0;
            public HashSet<ValueType> Dependents = new HashSet<ValueType>();
        }

        private Dictionary<ValueType, Relations> _map = new Dictionary<ValueType, Relations>();

        public void Add(ValueType obj)
        {
            if (!_map.ContainsKey(obj)) _map.Add(obj, new Relations());
        }

        public void Add(ValueType obj, ValueType dependency)
        {
            if (dependency.Equals(obj)) return;

            if (!_map.ContainsKey(dependency)) _map.Add(dependency, new Relations());

            var dependents = _map[dependency].Dependents;

            if (!dependents.Contains(obj))
            {
                dependents.Add(obj);

                if (!_map.ContainsKey(obj)) _map.Add(obj, new Relations());

                ++_map[obj].Dependencies;
            }
        }

        public void Add(ValueType obj, IEnumerable<ValueType> dependencies)
        {
            foreach (var dependency in dependencies) Add(obj, dependency);
        }

        public void Add(ValueType obj, params ValueType[] dependencies)
        {
            Add(obj, dependencies as IEnumerable<ValueType>);
        }

        public Tuple<IEnumerable<ValueType>, IEnumerable<ValueType>> Sort()
        {
            List<ValueType> sorted = new List<ValueType>(), cycled = new List<ValueType>();
            var map = _map.ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

            sorted.AddRange(map.Where(kvp => kvp.Value.Dependencies == 0).Select(kvp => kvp.Key));

            for (int idx = 0; idx < sorted.Count; ++idx) sorted.AddRange(map[sorted[idx]].Dependents.Where(k => --map[k].Dependencies == 0));

            cycled.AddRange(map.Where(kvp => kvp.Value.Dependencies != 0).Select(kvp => kvp.Key));

            return new Tuple<IEnumerable<ValueType>, IEnumerable<ValueType>>(sorted, cycled);
        }

        public void Clear()
        {
            _map.Clear();
        }
    }

}

/*
	Example usage with Task object
*/

namespace ExampleApplication
{
    using Algorithms;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class Task
    {
        public string Message;
    }

    class Program
    {
        static void Main(string[] args)
        {
            List<Task> tasks = new List<Task>
            {
                new Task{ Message = "A - depends on B and C" },    //0
                new Task{ Message = "B - depends on none" },       //1
                new Task{ Message = "C - depends on D and E" },    //2
                new Task{ Message = "D - depends on none" },       //3
                new Task{ Message = "E - depends on F, G and H" }, //4
                new Task{ Message = "F - depends on I" },          //5
                new Task{ Message = "G - depends on none" },       //6
                new Task{ Message = "H - depends on none" },       //7
                new Task{ Message = "I - depends on none" },       //8
            };

            TopologicalSorter<Task> resolver = new TopologicalSorter<Task>();

            // now setting relations between them as described above
            resolver.Add(tasks[0], new[] { tasks[1], tasks[2] });
            //resolver.Add(tasks[1]); // no need for this since the task was already mentioned as a dependency
            resolver.Add(tasks[2], new[] { tasks[3], tasks[4] });
            //resolver.Add(tasks[3]); // no need for this since the task was already mentioned as a dependency
            resolver.Add(tasks[4], tasks[5], tasks[6], tasks[7]);
            resolver.Add(tasks[5], tasks[8]);
            //resolver.Add(tasks[6]); // no need for this since the task was already mentioned as a dependency
            //resolver.Add(tasks[7]); // no need for this since the task was already mentioned as a dependency

            //resolver.Add(tasks[3], tasks[0]); // uncomment this line to test cycled dependency

            var result = resolver.Sort();
            var sorted = result.Item1;
            var cycled = result.Item2;

            if (!cycled.Any())
            {
                foreach (var d in sorted) Console.WriteLine(d.Message);
            }
            else
            {
                Console.Write("Cycled dependencies detected: ");

                foreach (var d in cycled) Console.Write($"{d.Message[0]} ");

                Console.WriteLine();
            }

            Console.WriteLine("exiting...");
        }
    }
}
