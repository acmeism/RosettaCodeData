using System;
using System.Collections.Generic;

namespace RosettaSearchListofRecords
{
    class Program
    {
        static void Main(string[] args)
        {
            var dataset = new List<Dictionary<string, object>>() {
                new Dictionary<string, object>   {{ "name" , "Lagos"},                {"population", 21.0  }},
                new Dictionary<string, object>   {{ "name" , "Cairo"},                {"population", 15.2  }},
                new Dictionary<string, object>   {{ "name" , "Kinshasa-Brazzaville"}, {"population", 11.3  }},
                new Dictionary<string, object>   {{ "name" , "Greater Johannesburg"}, {"population",  7.55 }},
                new Dictionary<string, object>   {{ "name" , "Mogadishu"},            {"population",  5.85 }},
                new Dictionary<string, object>   {{ "name" , "Khartoum-Omdurman"},    {"population",  4.98 }},
                new Dictionary<string, object>   {{ "name" , "Dar Es Salaam"},        {"population",  4.7  }},
                new Dictionary<string, object>   {{ "name" , "Alexandria"},           {"population",  4.58 }},
                new Dictionary<string, object>   {{ "name" , "Abidjan"},              {"population",  4.4  }},
                new Dictionary<string, object>   {{ "name" , "Casablanca"},           {"population",  3.98 }}
            };

            // Find the (zero-based) index of the first city in the list whose name is "Dar Es Salaam"
            var index = dataset.FindIndex(x => ((string)x["name"]) == "Dar Es Salaam");
            Console.WriteLine(index);

            // Find the name of the first city in this list whose population is less than 5 million
            var name = (string)dataset.Find(x => (double)x["population"] < 5.0)["name"];
            Console.WriteLine(name);

            // Find the population of the first city in this list whose name starts with the letter "A"
            var aNamePopulation = (double)dataset.Find(x => ((string)x["name"]).StartsWith("A"))["population"];
            Console.WriteLine(aNamePopulation);
        }
    }
}
