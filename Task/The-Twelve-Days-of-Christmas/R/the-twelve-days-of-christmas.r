gifts <- c("A partridge in a pear tree.", "Two turtle doves and", "Three french hens", "Four calling birds", "Five golden rings", "Six geese a-laying", "Seven swans a-swimming", "Eight maids a-milking", "Nine ladies dancing", "Ten lords a-leaping", "Eleven pipers piping", "Twelve drummers drumming")
days <- c("first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth")

for (i in seq_along(days)) {
  cat("On the", days[i], "day of Christmas\n")
  cat("My true love gave to me:\n")
  cat(paste(gifts[i:1], collapse = "\n"), "\n\n")
}
