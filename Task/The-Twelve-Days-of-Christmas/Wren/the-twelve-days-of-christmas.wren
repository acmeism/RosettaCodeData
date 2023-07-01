var days = [
    "first", "second", "third", "fourth", "fifth", "sixth",
    "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"
]

var gifts = [
    "A partridge in a pear tree.", "Two turtle doves and", "Three french hens",
    "Four calling birds", "Five golden rings", "Six geese a-laying",
    "Seven swans a-swimming", "Eight maids a-milking", "Nine ladies dancing",
    "Ten lords a-leaping", "Eleven pipers piping", "Twelve drummers drumming"
]

for (i in 0..11) {
    System.print("On the %(days[i]) day of Christmas,")
    System.print("My true love gave to me:")
    for (j in i..0) System.print(gifts[j])
    System.print()
}
