using System;
using System.Collections.Generic;
using System.Linq;

namespace HashJoin
{
    public class AgeName
    {
        public AgeName(byte age, string name)
        {
            Age = age;
            Name = name;
        }
        public byte Age { get; private set; }
        public string Name { get; private set; }
    }

    public class NameNemesis
    {
        public NameNemesis(string name, string nemesis)
        {
            Name = name;
            Nemesis = nemesis;
        }
        public string Name { get; private set; }
        public string Nemesis { get; private set; }
    }

    public class DataContext
    {
        public DataContext()
        {
            AgeName = new List<AgeName>();
            NameNemesis = new List<NameNemesis>();
        }
        public List<AgeName> AgeName { get; set; }
        public List<NameNemesis> NameNemesis { get; set; }
    }

    public class AgeNameNemesis
    {
        public AgeNameNemesis(byte age, string name, string nemesis)
        {
            Age = age;
            Name = name;
            Nemesis = nemesis;
        }
        public byte Age { get; private set; }
        public string Name { get; private set; }
        public string Nemesis { get; private set; }
    }

    class Program
    {
        public static void Main()
        {
            var data = GetData();
            var result = ExecuteHashJoin(data);
            WriteResultToConsole(result);
        }

        private static void WriteResultToConsole(List<AgeNameNemesis> result)
        {
            result.ForEach(ageNameNemesis => Console.WriteLine("Age: {0}, Name: {1}, Nemesis: {2}",
                ageNameNemesis.Age, ageNameNemesis.Name, ageNameNemesis.Nemesis));
        }

        private static List<AgeNameNemesis> ExecuteHashJoin(DataContext data)
        {
            return (data.AgeName.Join(data.NameNemesis,
                ageName => ageName.Name, nameNemesis => nameNemesis.Name,
                (ageName, nameNemesis) => new AgeNameNemesis(ageName.Age, ageName.Name, nameNemesis.Nemesis)))
                .ToList();
        }

        private static DataContext GetData()
        {
            var context = new DataContext();

            context.AgeName.AddRange(new [] {
                    new AgeName(27, "Jonah"),
                    new AgeName(18, "Alan"),
                    new AgeName(28, "Glory"),
                    new AgeName(18, "Popeye"),
                    new AgeName(28, "Alan")
                });

            context.NameNemesis.AddRange(new[]
            {
                new NameNemesis("Jonah", "Whales"),
                new NameNemesis("Jonah", "Spiders"),
                new NameNemesis("Alan", "Ghosts"),
                new NameNemesis("Alan", "Zombies"),
                new NameNemesis("Glory", "Buffy")
            });

            return context;
        }
    }
}
