using System;

class NumberNamer {
    static readonly string[] incrementsOfOne =
            { "zero",    "one",     "two",       "three",    "four",
              "five",    "six",     "seven",     "eight",    "nine",
              "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
              "fifteen", "sixteen", "seventeen", "eighteen", "nineteen" };

    static readonly string[] incrementsOfTen =
            { "",      "",      "twenty",  "thirty", "fourty",
              "fifty", "sixty", "seventy", "eighty", "ninety" };

    const string millionName = "million",
                 thousandName = "thousand",
                 hundredName = "hundred",
                 andName = "and";


    public static string GetName( int i ) {
        string output = "";
        if( i >= 1000000 ) {
            output += ParseTriplet( i / 1000000 ) + " " + millionName;
            i %= 1000000;
            if( i == 0 ) return output;
        }

        if( i >= 1000 ) {
            if( output.Length > 0 ) {
                output += ", ";
            }
            output += ParseTriplet( i / 1000 ) + " " + thousandName;
            i %= 1000;
            if( i == 0 ) return output;
        }

        if( output.Length > 0 ) {
            output += ", ";
        }
        output += ParseTriplet( i );
        return output;
    }


    static string ParseTriplet( int i ) {
        string output = "";
        if( i >= 100 ) {
            output += incrementsOfOne[i / 100] + " " + hundredName;
            i %= 100;
            if( i == 0 ) return output;
        }

        if( output.Length > 0 ) {
            output += " " + andName + " ";
        }
        if( i >= 20 ) {
            output += incrementsOfTen[i / 10];
            i %= 10;
            if( i == 0 ) return output;
        }

        if( output.Length > 0 ) {
            output += " ";
        }
        output += incrementsOfOne[i];
        return output;
    }
}


class Program { // Test class
    static void Main( string[] args ) {
        Console.WriteLine( NumberNamer.GetName( 1 ) );
        Console.WriteLine( NumberNamer.GetName( 234 ) );
        Console.WriteLine( NumberNamer.GetName( 31337 ) );
        Console.WriteLine( NumberNamer.GetName( 987654321 ) );
    }
}
