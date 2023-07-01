public class TwelveDaysOfChristmas {

    final static String[] gifts = {
        "A partridge in a pear tree.", "Two turtle doves and",
        "Three french hens", "Four calling birds",
        "Five golden rings", "Six geese a-laying",
        "Seven swans a-swimming", "Eight maids a-milking",
        "Nine ladies dancing", "Ten lords a-leaping",
        "Eleven pipers piping", "Twelve drummers drumming",
        "And a partridge in a pear tree.", "Two turtle doves"
    };

    final static String[] days = {
        "first", "second", "third", "fourth", "fifth", "sixth", "seventh",
        "eighth", "ninth", "tenth", "eleventh", "Twelfth"
    };

    public static void main(String[] args) {
        for (int i = 0; i < days.length; i++) {
            System.out.printf("%nOn the %s day of Christmas%n", days[i]);
            System.out.println("My true love gave to me:");
            for (int j = i; j >= 0; j--)
                System.out.println(gifts[i == 11 && j < 2 ? j + 12 : j]);
        }
    }
}
