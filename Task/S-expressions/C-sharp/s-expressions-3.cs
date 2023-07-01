using System;
using System.Collections.Generic;

namespace SExpression.Test
{
    class Program
    {
        static void Main(string[] args)
        {
            var str =
@"((data ""quoted data"" 123 4.5)
(data(!@# (4.5) ""(more"" ""data)"")))";

            var se = new SExpression();
            var node = se.Deserialize(str);
            var result = se.Serialize(node);
            Console.WriteLine(result);
        }
    }
}
