using System;

public class TwelveDaysOfChristmas {

    public static void Main() {

        string[] days = new string[12] {
            "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth",
            "tenth", "eleventh", "twelfth",
        };

        string[] gifts = new string[12] {
            "A partridge in a pear tree",
            "Two turtle doves",
            "Three french hens",
            "Four calling birds",
            "Five golden rings",
            "Six geese a-laying",
            "Seven swans a-swimming",
            "Eight maids a-milking",
            "Nine ladies dancing",
            "Ten lords a-leaping",
            "Eleven pipers piping",
            "Twelve drummers drumming"
        };

        for ( int i = 0; i < 12; i++ ) {

            Console.WriteLine("On the " + days[i] + " day of Christmas, my true love gave to me");

            int j = i + 1;
            while ( j-- > 0 )
                Console.WriteLine(gifts[j]);

            Console.WriteLine();

            if ( i == 0 )
                gifts[0] = "And a partridge in a pear tree";
        }

    }

}
