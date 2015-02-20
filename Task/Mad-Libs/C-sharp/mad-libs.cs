using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
namespace madLibs {
    class Program {
        static void Main(string[] args) {
            string name, sex, addThis, thing;
            bool isMale = false;
            Console.Write("Enter a name: ");
            name = Console.ReadLine();
            while(isMale == false) {
                Console.Write("Is that a male or female name? [m/f] ");
                sex = Console.ReadLine().ToLower().ToCharArray()[0].ToString();
                if(sex == "m") { isMale = true; } else if(sex == "f") { break; }
            }
            if (isMale){ addThis = "He "; }else{ addThis = "She "; }
            Console.Write("Enter a thing: ");
            thing = Console.ReadLine();
            Console.WriteLine(Environment.NewLine + String.Format(("{0} went for a walk in the park. " + addThis +
                "found a {1}. {0} decided to take it home."), name, thing));
            Console.ReadKey();
        }
    }
}
